import Combine
import Foundation
import OpenpathMobile

/// The shape of the callback functions we provide
typealias OpenpathCallback<T> = (Result<T, OpenpathErrorMessageAndCode>) -> Void

// Alias some of the auto-generated types to make them more intuitive
typealias LoginResponse = DescribeAccessToken200ResponseData
typealias ListedCredential = ListCredentialConfigs200ResponseDataInnerCredential
typealias TokenScope = DescribeAccessToken200ResponseDataTokenScopeListInner

/**
 Parse the error dictionary returned from the Openpath SDK, if present.
 */
private func extractError(from data: [String: Any]) -> OpenpathErrorMessageAndCode? {
    guard let err = data["err"] as? [String: String],
          let message = err["message"],
          let code = err["code"]
    else {
        return nil
    }
    return OpenpathErrorMessageAndCode(message: message, code: code)
}

private let jsonDecoder = JSONDecoder()

/**
 Decode the data dictionary returned from the Openpath SDK.
 */
private func decode<T>(message: [String: Any]) throws -> T where T: Decodable {
    let data = try JSONSerialization.data(withJSONObject: message)
    let decoded = try jsonDecoder.decode(InData<T>.self, from: data)
    return decoded.data
}

private var requestId = Int(Date.now.timeIntervalSince1970 * 1000.0)

private func getRequestId() -> Int {
    requestId += 1
    return requestId
}

/**
 A wrapper around the OpenpathMobileAccessCore SDK and the Openpath REST API.

 This wrapper updates the interface to provide:
  * More robust type-safety
  * A callback-based interface to complement the delegate-based one
  * async/await support on targets that support it
 */
@MainActor
class OpenpathWrapper {
    static let shared = OpenpathWrapper()

    var delegate: OpenpathMobileAccessCoreDelegate?

    var authorizationHeader: String? {
        set {
            OpenpathAPI.customHeaders["Authorization"] = newValue
        }
        get {
            OpenpathAPI.customHeaders["Authorization"]
        }
    }

    private let jsonDecoder = JSONDecoder()

    var openpath: OpenpathMobileAccessCore {
        OpenpathMobileAccessCore.shared
    }

    let openpathData = OpenpathData()

    init() {
        openpath.delegate = self
        let allErrors = openpath.getErrors()
        appLog.debug("\(allErrors)")
    }

    // MARK: - Event publishers

    // Subscribe to these events using `.sink()` as described here:
    // https://developer.apple.com/documentation/combine/receiving-and-handling-events-with-combine

    let onDebug = PassthroughSubject<String, Never>()
    let onItemsSet = PassthroughSubject<OpenpathData.ItemsSet, Never>()
    let onItemsUpdated = PassthroughSubject<OpenpathData.ItemsUpdate, Never>()
    let onItemStatesUpdated = PassthroughSubject<ItemStatesUpdate, Never>()
    let onBluetoothStatusChanged = PassthroughSubject<BluetoothStatusChanged, Never>()
    let onInternetStatusChanged = PassthroughSubject<Bool, Never>()

    // MARK: - API functions

    /**
     * Log in using email, password, and optionally multifactor authentication.
     *
     * This is one of two ways to log into the app. The most common way is using an access token.
     *
     * - Parameters:
     *   - email: Email address, Required
     *   - password: Password. Required
     *   - mfa: One-time-use token returned from an authentication app, for multifactor auth. Required only if the account is so configured
     *
     * - Returns:Login Response object
     *
     *  The returned object includes a `token` which this wrapper automatically will apply to the "Authentication" header in future API requests.
     *  You should then:
     *  - Parse the `tokenScopeList` and if there is more than one viable `org` provide some way of selecting which one to connect to.
     *  - Call `listCredentials` to get the list of credentials for this user/org combination. If there is more than one credential, select one
     *    interactively.
     *  - Call `generateSetupMobileToken` to convert the `orgId`, `userId`, and `credentialId` into a token for future SDK calls.
     *  - Call `provision`, then `switchUser`, then `syncUser` in sequence.
     */
    func login(email: String, password: String, mfa: String) async throws -> LoginResponse {
        clearAuthorizationHeader()
        let loginData = try await AuthAPI.login(body: LoginRequest(email: email,
                                                                   password: password,
                                                                   mfa: mfa
                                                                       .isEmpty ? nil : LoginRequestMfa(totpCode: mfa),
                                                                   forMobileLogin: true)).data
        authorizationHeader = loginData.token
        return loginData
    }

    func loginAll(email: String, password: String, mfa: String) async throws -> [LoginResponse] {
        clearAuthorizationHeader()
        let loginAllData = try await AuthAPI.loginAll(body: LoginAllRequest(email: email,
                                                                            password: password,
                                                                            mfa: mfa
                                                                                .isEmpty ? nil :
                                                                                LoginRequestMfa(totpCode: mfa),
                                                                            forMobileLogin: true)).data

        if loginAllData.count == 1 {
            authorizationHeader = loginAllData.first!.token
        }

        return loginAllData
    }

    /**
     * Use the token contained in this login response for future API calls.
     */
    func select(loginResponse: LoginResponse) {
        authorizationHeader = loginResponse.token
    }

    /**
     * Clear authorization header, in preparation for  adding another account
     */
    func clearAuthorizationHeader() {
        authorizationHeader = nil
    }

    /**
     * List credentials available to the `orgId` and `userId` combination.
     *
     * Get those values from calling `login`.
     */
    func listCredentials(orgId: Int, userId: Int) async throws -> [ListedCredential] {
        return try await OrgsUsersAPI.listCredentials(orgId: orgId, userId: userId).data
    }

    func listMobileCredentials(orgId: Int, userId: Int) async throws -> [ListedCredential] {
        return try await OrgsUsersAPI.listCredentials(orgId: orgId,
                                                      userId: userId,
                                                      filter: "credentialType.id:(=1)").data
    }

    /**
     * Convert `orgId`, `userId`, and `credentialId` into a token for SDK access.
     *
     * Get those values by calling `login` and then `listCredentials`.
     */
    func generateSetupMobileToken(orgId: Int, userId: Int, credentialId: Int) async throws -> String {
        let setupMobileTokenData = try await OrgsUsersAPI.generateSetupMobileToken(orgId: orgId,
                                                                                   userId: userId,
                                                                                   credentialId: credentialId).data
        let setupMobileToken = setupMobileTokenData.setupMobileToken

        return setupMobileToken
    }

    // MARK: - SDK functions

    /**
     * Provisions app with an Openpath user and saves their info and credentials for later use.
     *
     * - Parameters:
     *  - setupMobileToken: The token for a specific user and credential, returned from `generateSetupMobiletoken`
     *  - callback: Async callback for provision completion
     *
     * - Note: It may be more convenient to call the async version of this function.
     */
    func provision(setupMobileToken: String, callback: @escaping (Result<ProvisionResult, OpenpathError>) -> Void) {
        precondition(Thread.isMainThread)
        openpath.provision(setupMobileToken: setupMobileToken, callback: callback)
    }

    /**
     * Async version of `provision`
     */
    func provision(setupMobileToken: String) async throws -> ProvisionResult {
        try await withCheckedThrowingContinuation { continuation in
            self.provision(setupMobileToken: setupMobileToken, callback: continuation.resume)
        }
    }

    private var onUnprovisionCallback: OpenpathCallback<UnprovisionResponse>?
    /**
     * Unprovision
     *
     * Clears the Openpath user data for the requested user. If the app has multiple users provisioned,
     *  the requested user can not be the active user. If no user is provided, the SDK will unprovision all
     *  of the provisioned users in the app.
     */
    private func unprovision(userOpal: String?, callback: @escaping OpenpathCallback<UnprovisionResponse>) {
        precondition(Thread.isMainThread)
        precondition(onUnprovisionCallback == nil, "\(#function) Call already in progress")
        onUnprovisionCallback = callback
        openpath.unprovision(userOpal: userOpal)
    }

    @discardableResult
    func unprovision(userOpal: String?) async throws -> UnprovisionResponse {
        try await withCheckedThrowingContinuation { continuation in
            self.unprovision(userOpal: userOpal, callback: continuation.resume)
        }
    }

    private var onSwitchUserCallback: OpenpathCallback<SwitchUserResponse>?

    /**
     * Call this immediately after a successful return from `provision`.
     *
     * - Note: It may be more convenient to call the async version of this function.
     */
    func switchUser(userOpal: String, callback: @escaping OpenpathCallback<SwitchUserResponse>) {
        precondition(Thread.isMainThread)
        precondition(onSwitchUserCallback == nil, "\(#function) Call already in progress")
        onSwitchUserCallback = callback
        openpath.switchUser(userOpal: userOpal)
    }

    /**
     * Async version of `switchUser`
     */
    @discardableResult
    func switchUser(userOpal: String) async throws -> SwitchUserResponse {
        try await withCheckedThrowingContinuation { continuation in
            self.switchUser(userOpal: userOpal, callback: continuation.resume)
        }
    }

    private var onSyncUserCallback: OpenpathCallback<SyncUserResponse>?

    /**
     * Call this immediately after a successful return from `switchUser`.
     *
     * - Note: It may be more convenient to call the async version of this function.
     */
    func syncUser(callback: @escaping OpenpathCallback<SyncUserResponse>) {
        precondition(Thread.isMainThread)
        precondition(onSyncUserCallback == nil, "\(#function) Call already in progress")
        onSyncUserCallback = callback
        openpath.syncUser()
    }

    /**
     * Async version of `syncUser`
     */
    func syncUser() async throws -> SyncUserResponse {
        try await withCheckedThrowingContinuation { continuation in
            self.syncUser(callback: continuation.resume)
        }
    }

    private var onUnlockCallbacks = [Int: [OpenpathCallback<UnlockResponse>]]()

    /**
     * Unlock an entry or reader.
     *
     * - Note: If there is already an unlock request in progress for the `itemId`, will not make a second request
     *
     * - Parameters:
     *   - itemType: Entry or Reader
     *   - itemId:
     *   - requestId: A unique random integer for tracking this unlock request
     *   - timeout: Milliseconds to wait until the request returns a timeout error
     */
    func unlock(
        itemType: ItemType,
        itemId: Int,
        requestId: Int,
        timeout: Int,
        callback: @escaping OpenpathCallback<UnlockResponse>
    ) {
        precondition(Thread.isMainThread)

        // If there's already an unlock call in progress for this item, don't call it again.
        if var callbacks = onUnlockCallbacks[requestId] {
            callbacks.append(callback)
        } else {
            onUnlockCallbacks[requestId] = [callback]
        }
        openpathLog.info("UNLOCK: \(itemType.rawValue), \(itemId)")
        openpath.unlock(itemType: itemType.rawValue, itemId: itemId, requestId: Int(requestId), timeout: timeout)
    }

    /**
     * Async version of `unlock`
     */
    func unlock(itemType: ItemType, itemId: Int, requestId: Int = getRequestId(),
                timeout: Int = 8000) async throws -> UnlockResponse {
        try await withCheckedThrowingContinuation { continuation in
            self.unlock(itemType: itemType,
                        itemId: itemId,
                        requestId: requestId,
                        timeout: timeout,
                        callback: continuation.resume)
        }
    }

    enum ConnectionType: String {
        case wifi
        case ble
        case cloud
    }

    /**
     For internal or testing purposes only.
     */
    func _unlockSpecial(itemType: ItemType,
                        itemId: Int,
                        connectionType: ConnectionType,
                        requestId: Int = getRequestId(),
                        timeout: Int = 8000,
                        callback: @escaping OpenpathCallback<UnlockResponse>) {
        precondition(Thread.isMainThread)

        // If there's already an unlock call in progress for this item, don't call it again.
        if var callbacks = onUnlockCallbacks[requestId] {
            callbacks.append(callback)
        } else {
            onUnlockCallbacks[requestId] = [callback]
        }
        openpath._unlockByConnectionType(connectionType: connectionType.rawValue,
                                         itemType: itemType.rawValue,
                                         itemId: itemId,
                                         requestId: requestId,
                                         timeout: timeout)
    }

    /**
     For internal or testing purposes only.
     */
    func _unlockSpecial(itemType: ItemType,
                        itemId: Int,
                        connectionType: ConnectionType,
                        requestId: Int = getRequestId(),
                        timeout: Int = 8000) async throws -> UnlockResponse {
        try await withCheckedThrowingContinuation { continuation in
            self._unlockSpecial(itemType: itemType,
                                itemId: itemId,
                                connectionType: connectionType,
                                requestId: requestId,
                                timeout: timeout,
                                callback: continuation.resume)
        }
    }

    /**
     For internal or testing purposes only.
     */
    func _getTermsOfUseStatus(identityId: Int) async throws -> OpenpathTermsOfUseStatus {
        try await withCheckedThrowingContinuation { continuation in
            openpath._getTermsOfUseStatus(identityId: identityId, callback: continuation.resume)
        }
    }

    private var onRefreshItemStateCallback = [Int: OpenpathCallback<ItemState>]()
    func refreshItemState(itemType: ItemType, itemId: Int, callback: @escaping OpenpathCallback<ItemState>) {
        precondition(Thread.isMainThread)
        precondition(onRefreshItemStateCallback[itemId] == nil, "\(#function) Call already in progress")
        onRefreshItemStateCallback[itemId] = callback
        openpath.refreshItemState(itemType: itemType.rawValue, itemId: itemId)
    }

    func refreshItemState(itemType: ItemType, itemId: Int) async throws -> ItemState {
        try await withCheckedThrowingContinuation { continuation in
            self.refreshItemState(itemType: itemType, itemId: itemId, callback: continuation.resume)
        }
    }

    func getReadersInRange(rssiThreshold: Int = 0) -> [ReaderInRange] {
        let responseDict = openpath.getReadersInRange(rssiThreshold: rssiThreshold)
        do {
            let response: [ReaderInRange] = try decode(message: responseDict)
            return response // .readersInRange
        } catch {
            openpathLog.error("Failed to get readers in range: \(responseDict)")
            return []
        }
    }

    func getSdkVersion() -> String {
        let responseDict = openpath.getSdkVersion()
        return (responseDict["data"] as! [String: String])["sdkVersion"]!
    }

    func getErrors() -> [OpenpathErrorMessageAndCode] {
        let responseDict = openpath.getErrors()
        let response: GetErrorsResponse = try! decode(message: responseDict)
        return response.errors
    }

    func getAuthorizationStatuses() -> [AuthorizationStatus] {
        let responseDict = openpath.getAuthorizationStatuses()
        let response: GetAuthorizationStatusesResponse = try! decode(message: responseDict)

        return response.authorizationStatuses
    }

    func requestAuthorization(_ authType: AuthType) {
        openpath.requestAuthorization(authType.rawValue)
    }

    /**
     * Request the needed OS-level permissions from the user.
     */
    func requestUnrequestedPermissions() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) { [self] in
            let statuses = getAuthorizationStatuses()
            for status in statuses {
                if status.authType != .notification, status.status == .notDetermined {
                    requestAuthorization(status.authType)
                }
            }
            // Since there is no info about the current status of the notification authorization, request it each time.
            requestAuthorization(.notification)
        }
    }

    func softRefresh() {
        openpath.softRefresh()
    }
}

extension OpenpathWrapper: OpenpathMobileAccessCoreDelegate {
    /**
     Helper function: process a delegate callback from OpenpathMobileAccessCore
     - Parameters:
     - message: The `message` parameter from the delegate
     - callbackKeyPath: Key Path to a private property holding a callback to call, then clear.
     */
    fileprivate func processMessage<T>(_ message: [String: Any],
                                       callbackKeyPath: ReferenceWritableKeyPath<OpenpathWrapper,
                                           (
                                               (Result<
                                                   T,
                                                   OpenpathErrorMessageAndCode
                                               >) -> Void
                                           )?>) where T: Decodable {
        if let callback = self[keyPath: callbackKeyPath] {
            self[keyPath: callbackKeyPath] = nil

            if let error = extractError(from: message) {
                callback(.failure(error))
                return
            }
            do {
                let data = try JSONSerialization.data(withJSONObject: message)
                let response = try jsonDecoder.decode(InData<T>.self, from: data)
                callback(.success(response.data))
            } catch {
                callback(.failure(OpenpathErrorMessageAndCode(message: error.localizedDescription,
                                                              code: "JSON Deserialization Error")))
            }
        }
    }

    func openpathMobileAccessCore(_ openpathMobileAccessCore: OpenpathMobileAccessCore,
                                  onDebug message: [String: Any]) {
        delegate?.openpathMobileAccessCore(openpathMobileAccessCore, onDebug: message)
        guard let response: OnDebugResponse = try? decode(message: message) else {
            openpathLog.debug("SDK message: \(message, privacy: .private)")
            return
        }
        onDebug.send(response.message)
        openpathLog.debug("SDK message: \(response.message, privacy: .private)")
    }

    func openpathMobileAccessCore(
        _ openpathMobileAccessCore: OpenpathMobileAccessCore,
        onBluetoothStatusChanged message: [String: Any]
    ) {
        delegate?.openpathMobileAccessCore(openpathMobileAccessCore, onBluetoothStatusChanged: message)

        let data: BluetoothStatusChanged = try! decode(message: message)
        onBluetoothStatusChanged.send(data)
    }

    func openpathMobileAccessCore(
        _ openpathMobileAccessCore: OpenpathMobileAccessCore,
        onInternetStatusChanged message: [String: Any]
    ) {
        delegate?.openpathMobileAccessCore(openpathMobileAccessCore, onInternetStatusChanged: message)

        let data: InternetStatusChanged = try! decode(message: message)
        onInternetStatusChanged.send(data.isInternetAvailable)
    }

    func openpathMobileAccessCore(
        _ openpathMobileAccessCore: OpenpathMobileAccessCore,
        onUserSettingsSet message: [String: Any]
    ) {
        delegate?.openpathMobileAccessCore(openpathMobileAccessCore, onUserSettingsSet: message)
    }

    func openpathMobileAccessCore(
        _ openpathMobileAccessCore: OpenpathMobileAccessCore,
        onItemsSet message: [String: Any]
    ) {
        delegate?.openpathMobileAccessCore(openpathMobileAccessCore, onItemsSet: message)

        guard let data: OpenpathData.ItemsSet = try? decode(message: message) else {
            // This happens the first time every time, unfortunately
            openpathLog.warning("Invalid message passed to onItemsSet: \(message)")
            return
        }

        onItemsSet.send(data)

        openpathData.items = data.items
        openpathData.itemOrdering = data.itemOrdering

        let itemsString = openpathData.items.map { key, value in
            "\(key): \(value)"
        }.joined(separator: ", ")
        openpathLog.info("Items set to \(itemsString)")
    }

    func openpathMobileAccessCore(
        _ openpathMobileAccessCore: OpenpathMobileAccessCore,
        onItemsUpdated message: [String: Any]
    ) {
        delegate?.openpathMobileAccessCore(openpathMobileAccessCore, onItemsUpdated: message)

        let data: OpenpathData.ItemsUpdate = try! decode(message: message)

        onItemsUpdated.send(data)

        openpathData.items.merge(data.items ?? [:]) { $1 }
        let itemsString = openpathData.items.map { key, value in
            "\(key): \(value)"
        }.joined(separator: ", ")
        openpathLog.info("Items updated to \(itemsString)")
    }

    func openpathMobileAccessCore(
        _ openpathMobileAccessCore: OpenpathMobileAccessCore,
        onItemStatesUpdated message: [String: Any]
    ) {
        delegate?.openpathMobileAccessCore(openpathMobileAccessCore, onItemStatesUpdated: message)

        do {
            let data: ItemStatesUpdate = try decode(message: message)
            onItemStatesUpdated.send(data)

            for item in data.itemStates.values {
                if let callback = onRefreshItemStateCallback[item.itemId] {
                    onRefreshItemStateCallback[item.itemId] = nil
                    callback(.success(item))
                }
            }
        } catch {
            openpathLog.error("Failed to decode onItemStatesUpdated message \(message, privacy: .private)")
        }
    }

    /**
     * Handle result of `unlock` call.
     *
     * Note that this is different from other delegate methods, because there can be multiple `unlock` calls in progress.
     */
    func openpathMobileAccessCore(
        _ openpathMobileAccessCore: OpenpathMobileAccessCore,
        onUnlockResponse message: [String: Any]
    ) {
        precondition(Thread.isMainThread)

        delegate?.openpathMobileAccessCore(openpathMobileAccessCore, onUnlockResponse: message)

        do {
            let response: UnlockResponse = try decode(message: message)
            let requestId = response.requestId
            guard let callbacks = onUnlockCallbacks[requestId] else {
                return
            }
            onUnlockCallbacks[requestId] = nil
            for callback in callbacks {
                callback(.success(response))
            }
        } catch {
            openpathLog.error("JSON Deserialization Error in onUnlockResponse: \(message, privacy: .private)")
        }
    }

    func openpathMobileAccessCore(
        _ openpathMobileAccessCore: OpenpathMobileAccessCore,
        onSyncUserResponse message: [String: Any]
    ) {
        delegate?.openpathMobileAccessCore(openpathMobileAccessCore, onSyncUserResponse: message)
        processMessage(message, callbackKeyPath: \.onSyncUserCallback)
    }

    func openpathMobileAccessCore(
        _ openpathMobileAccessCore: OpenpathMobileAccessCore,
        onSwitchUserResponse message: [String: Any]
    ) {
        delegate?.openpathMobileAccessCore(openpathMobileAccessCore, onSwitchUserResponse: message)
        processMessage(message, callbackKeyPath: \.onSwitchUserCallback)
    }

    func openpathMobileAccessCore(
        _ openpathMobileAccessCore: OpenpathMobileAccessCore,
        onProvisionResponse message: [String: Any]
    ) {
        delegate?.openpathMobileAccessCore(openpathMobileAccessCore, onProvisionResponse: message)
    }

    func openpathMobileAccessCore(
        _ openpathMobileAccessCore: OpenpathMobileAccessCore,
        onUnprovisionResponse message: [String: Any]
    ) {
        delegate?.openpathMobileAccessCore(openpathMobileAccessCore, onUnprovisionResponse: message)
        processMessage(message, callbackKeyPath: \.onUnprovisionCallback)
    }
}
