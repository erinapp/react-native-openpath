import Combine
import Foundation

/**
 * Encapsulates login logic for use by the UI layer.
 *
 * This general approach that can be reused in all apps, however for clarity in development this provides more technical
 * details than would likely be included in a customer-focused app.
 */
@MainActor
class LoginViewModel: ObservableObject {
    /**
     * Where we are in the login process
     */
    enum LoginState {
        /// User has not yet logged in or has logged out
        case loggedOut

        /// Something has come up during the login process that requires asking the user a question.
        case question(question: String,
                      choices: [QuestionChoice],
                      answer: (QuestionChoice) -> Void,
                      cancel: () -> Void)

        /// User is fully logged in
        case loggedIn(user: OpenpathUser)
    }

    /**
     * The ways a user can log in: By email and password or a token
     */
    enum LoginMethod {
        case email
        case token

        mutating func toggle() {
            switch self {
            case .email:
                self = .token
            case .token:
                self = .email
            }
        }
    }

    // During development, you can provide login credentials via environment variables.
    // CAUTION: Do not put those credentials into a shared XCode scheme or source control.
    @Published var email: String = ProcessInfo.processInfo.environment["DEBUG_EMAIL"] ?? "" {
        didSet {
            errorMessage = nil
        }
    }

    @Published var password: String = ProcessInfo.processInfo.environment["DEBUG_PASSWORD"] ?? "" {
        didSet {
            errorMessage = nil
        }
    }

    @Published var multifactor: String = "" {
        didSet {
            errorMessage = nil
        }
    }

    @Published var setupMobileToken: String = ProcessInfo.processInfo.environment["DEBUG_TOKEN"] ?? "" {
        didSet {
            errorMessage = nil
        }
    }

    @Published var loginMethod: LoginMethod = .email {
        didSet {
            errorMessage = nil
        }
    }

    /// Message to show if there's an error
    @Published private(set) var errorMessage: String?

    /// Message to show while the SDK or API is busy doing something
    @Published private(set) var busyMessage: String?

    /// Where we are in the login process
    @Published private(set) var loginState: LoginState = .loggedOut {
        didSet {
            if case .loggedOut = loginState {
                tokenScope = nil
                setupMobileToken = ""
            }
        }
    }

    var loginViewHeader: String {
        switch loginState {
        case .loggedOut:
            return "Welcome to Openpath"
        default:
            return "Add Account"
        }
    }

    var loginButtonLabel: String {
        switch loginMethod {
        case .email:
            return "Log In"
        case .token:
            return "Provision"
        }
    }

    var toggleButtonLabel: String {
        switch loginMethod {
        case .email:
            return "Switch to token login"
        case .token:
            return "Switch to email and password"
        }
    }

    var canLogin: Bool {
        switch loginMethod {
        case .email:
            return !email.isEmpty && !password.isEmpty
        case .token:
            return !setupMobileToken.isEmpty
        }
    }

    var sdkVersion: String {
        "Openpath Mobile Access Core version \(openpath.getSdkVersion())"
    }

    private lazy var openpath = OpenpathWrapper.shared

    /// Used to subscribe to the SDK wrapper's `onLogout` publisher so we know when the user logs out
    private var onLogoutSubscriber: AnyCancellable?

    /// Selected token scope from the API
    private var tokenScope: TokenScope?

    @Published private(set) var provisionedUsers = [OpenpathUser]() {
        didSet {
            if provisionedUsers != oldValue {
                LoginViewModel.save(users: provisionedUsers) { result in
                    switch result {
                    case let .success(count):
                        appLog.debug("Saved \(count) provisioned users")
                    case let .failure(error):
                        appLog.error("Failed to save provisioned users: \(error.localizedDescription)")
                    }
                }
                if let firstUser = provisionedUsers.first {
                    loginState = .loggedIn(user: firstUser)
                    checkTermsOfUse(user: firstUser)
                } else {
                    loginState = .loggedOut
                }
            }
        }
    }

    private static func fileURL() -> URL {
        try! FileManager.default.url(for: .documentDirectory,
                                     in: .userDomainMask,
                                     appropriateFor: nil,
                                     create: false)
            .appendingPathComponent("users.json")
    }

    static func load(completion: @escaping (Result<[OpenpathUser], Error>) -> Void) {
        let fileURL = fileURL()
        DispatchQueue.global(qos: .background).async {
            do {
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let users = try JSONDecoder().decode([OpenpathUser].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(users))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    static func save(users: [OpenpathUser], completion: @escaping (Result<Int, Error>) -> Void) {
        let outfile = fileURL()
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(users)
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(users.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    init() {
        LoginViewModel.load { result in
            switch result {
            case let .success(users):
                self.provisionedUsers = users
                if let opal = users.first?.opal {
                    Task {
                        // TODO: Handle errors
                        _ = try? await self.openpath.switchUser(userOpal: opal)
                        _ = try? await self.openpath.syncUser()
                    }
                }
            case let .failure(error):
                appLog.error("Error loading provisioned users: \(error.localizedDescription)")
            }
        }
    }

    /**
     * Ask the user a question.
     *
     * This turns an interactive prompt into something we can call using `await` by:
     *  - Creating a continuation
     *  - Telling the UI layer to present the question
     *  - Resuming the continuation with the user's answer
     *
     *  If there is only one choice, skips the interactive portion and automatically chooses the first one.
     *  If there are no choices, throws an error.
     *  If the user cancels login, throws an OpenpathLoginCancelledError
     */
    private func ask<T>(question: String, choices: [T]) async throws -> T where T: QuestionChoice {
        switch choices.count {
        case 0:
            throw OpenpathErrorMessageAndCode(message: "\(question): No choices available")

        case 1:
            return choices.first!

        default:
            // Send the question and choices to the UI layer, along with `answer` and `cancel` callbacks
            busyMessage = nil
            return try await withCheckedThrowingContinuation { continuation in
                self.loginState = .question(question: question,
                                            choices: choices,
                                            answer: continuation.resume,
                                            cancel: {
                                                continuation.resume(throwing: OpenpathLoginCanceledError())
                                            })
            } as! T
        }
    }

    func login() {
        guard canLogin else {
            return
        }
        Task {
            switch loginMethod {
            case .email:
                await loginWithEmail()
            case .token:
                await provision()
            }
        }
    }

    private func loginWithEmail() async {
        do {
            openpath.clearAuthorizationHeader()
            errorMessage = nil
            busyMessage = "Logging in"
            defer {
                busyMessage = nil
            }

            // Login to all accounts that match the provided email and password
            let loginResponseList = try await openpath.loginAll(email: email, password: password, mfa: multifactor)

            // Decide which account to use, by asking the user if necessary
            let loginResponse = try await ask(question: "Choose Namespace", choices: loginResponseList)

            // Tell the API to use the authentication contained in the chosen login response
            openpath.select(loginResponse: loginResponse)

            // The API returns some token scopes with no user or org, so filter those out
            let usableTokenScopes = loginResponse.tokenScopeList.filter {
                $0.org.id != nil && $0.user.id != nil
            }

            // If this user is enrolled in multiple organizations, ask which one to use
            let tokenScope = try await ask(question: "Choose Organization", choices: usableTokenScopes)
            self.tokenScope = tokenScope
            // We verified these are non-nil above, so it's safe to force-unwrap
            let orgId = tokenScope.org.id!
            let userId = tokenScope.user.id!

            // Get the mobile credentials associated with this account and organization
            busyMessage = "Fetching credentials"
            let credentials = try await openpath.listMobileCredentials(orgId: orgId, userId: userId)

            // Decide which set of credentials to use, by asking the user if necessary
            let credential = try await ask(question: "Choose Credential", choices: credentials)

            // Convert that credential set into a `setupMobileToken`
            busyMessage = "Getting setup mobile token"
            setupMobileToken = try await openpath.generateSetupMobileToken(orgId: orgId,
                                                                           userId: userId,
                                                                           credentialId: credential.id)

            // Continue with the provisioning process using the acquired `setupMobileToken`
            await provision()
        } catch {
            handle(error: error, defaultMessage: "Unable to login")
        }
    }

    private func provision() async {
        do {
            errorMessage = nil
            busyMessage = "Provisioning"
            defer {
                busyMessage = nil
            }

            let provisionResponse = try await openpath.provision(setupMobileToken: setupMobileToken)

            await switchUser(userOpal: provisionResponse.userOpal)
        } catch {
            handle(error: error, defaultMessage: "Unable to provision")
        }
    }

    private func switchUser(userOpal: String) async {
        do {
            errorMessage = nil
            busyMessage = "Switching SDK user"
            defer {
                busyMessage = nil
            }

            let switchUserResponse = try await openpath.switchUser(userOpal: userOpal)

            guard switchUserResponse.userOpal == userOpal else {
                throw OpenpathErrorMessageAndCode(
                    message: "switchUser userOpal \(switchUserResponse.userOpal) != userOpal \(userOpal)"
                )
            }

            busyMessage = "Syncing SDK user"
            let syncUserResponse = try await openpath.syncUser()
            appLog.info("syncUser response \(syncUserResponse)")

            provisionedUsers = [syncUserResponse.user] + provisionedUsers.filter { $0.id != syncUserResponse.user.id }
            loginState = .loggedIn(user: syncUserResponse.user)
            checkTermsOfUse(user: syncUserResponse.user)
        } catch {
            handle(error: error, defaultMessage: "Unable to provision")
        }
    }

    private func checkTermsOfUse(user: OpenpathUser) {
        Task {
            do {
                let status = try await OpenpathWrapper.shared._getTermsOfUseStatus(identityId: user.identity.id)
                appLog.info("Got terms of use status: \(status)")
            } catch let e {
                appLog.error("Failed to get terms of use status: \(e)")
            }
        }
    }

    func switchTo(user: OpenpathUser) {
        if user != provisionedUsers.first {
            Task {
                await switchUser(userOpal: user.opal)
            }
        }
    }

    func unprovision(userOpal: String) {
        Task {
            await unprovisionAsync(userOpal: userOpal)
        }
    }

    private func unprovisionAsync(userOpal: String) async {
        busyMessage = "Unprovisioning user"
        errorMessage = nil
        defer {
            busyMessage = nil
        }
        let users = provisionedUsers
        guard let user = users.first(where: { $0.opal == userOpal }) else {
            appLog.error("Attempted to unprovision a nonprovisioned user with opal \(userOpal, privacy: .private)")
            return // Nothing to do
        }
        do {
            // If we're unprovisioning the primary account and there are multiple accounts provisioned,
            // we first must switch users.
            if user == users.first, users.count > 1 {
                try await openpath.switchUser(userOpal: users[1].opal)
            }
            try await openpath.unprovision(userOpal: userOpal)
            provisionedUsers = provisionedUsers.filter { $0.opal != userOpal }
        } catch {
            handle(error: error, defaultMessage: "Unable to unprovision")
        }
    }

    private func handle(error: Error, defaultMessage: String = "Unhandled error") {
        // If there's an error while adding an account, go back to the previous active user
        if let activeUser = provisionedUsers.first {
            loginState = .loggedIn(user: activeUser)
            checkTermsOfUse(user: activeUser)
        } else {
            loginState = .loggedOut
        }
        let prefix: String
        if let busyMessage {
            prefix = "\(busyMessage): "
        } else {
            prefix = ""
        }

        switch error {
        case let error as LocalizedError:
            errorMessage = "\(prefix)\(error.localizedDescription)"
        case let ErrorResponse.error(status, _, _, _):
            errorMessage = "\(prefix)HTTP status \(status)"
        default:
            errorMessage = "\(prefix)\(defaultMessage)"
        }
    }
}
