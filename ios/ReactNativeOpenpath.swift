//  Copyright © 2016-2022 OpenPath Security, Inc. All rights reserved.

import Foundation
import OpenpathMobile
import React
import UserNotifications

@objc(ReactNativeOpenpath)
public class ReactNativeOpenpath: RCTEventEmitter, OpenpathMobileAccessCoreDelegate {
    private weak static var instance: ReactNativeOpenpath?
    private var didInitialize = false

    /**
     Wrap this around calls to the OpenpathMobileAccessCore SDK.

     This ensures that the first time we reference `OpenpathMobileAccessCore.shared` it happens on the main queue,
     as required and documented.

     Subsequent calls stay on the calling thread, which will be within the React Native JavaScript Bridge.
     */
    private func apiCall(_ callback: @escaping (OpenpathMobileAccessCore) -> Void) {
        if didInitialize {
            callback(OpenpathMobileAccessCore.shared)
        } else {
            // NOTE: Due to the asynchronous nature of this dispatch, it's possible that more than
            // one call will take this path, if they happen in quick succession. That's okay.
            DispatchQueue.main.async { [self] in
                _ = OpenpathMobileAccessCore.shared
                didInitialize = true
                callback(OpenpathMobileAccessCore.shared)
            }
        }
    }

    public static var onHasListeners: ((ReactNativeOpenpath) -> Void)? {
        didSet {
            if let instance = ReactNativeOpenpath.instance,
               instance.hasListeners {
                onHasListeners?(instance)
            }
        }
    }

    var hasListeners = false {
        didSet {
            if let onHasListeners = ReactNativeOpenpath.onHasListeners,
               hasListeners {
                onHasListeners(self)
            }
        }
    }

    override init() {
        super.init()

        ReactNativeOpenpath.instance = self
    }

    // RCTEventEmitter supported events
    override public func supportedEvents() -> [String]! {
        return ["OpenpathEvent"]
    }

    override public func startObserving() {
        apiCall { openpath in
            openpath.delegate = self
        }
        hasListeners = true
    }

    override public func stopObserving() {
        hasListeners = false
    }

    // MARK: React Module functions

    // Framework documented public methods
    @objc
    func provision(_ setupMobileToken: String) {
        hasListeners = true
        apiCall { openpath in
            openpath.provision(setupMobileToken: setupMobileToken)
        }
    }

    // IMPORTANT: Seems like eventhoug react don't call this function when it calls to
    //  unprovision with nil/null/NULL it espect to have this api definded as well.
    @objc
    func unprovision(_ userOpal: String?) {
        apiCall { openpath in
            openpath.unprovision(userOpal: userOpal)
        }
    }

    @objc
    func syncUser() {
        hasListeners = true
        apiCall { openpath in
            openpath.syncUser()
        }
    }

    @objc
    func switchUser(_ userOpal: String) {
        hasListeners = true
        apiCall { openpath in
            openpath.switchUser(userOpal: userOpal)
        }
    }

    @objc
    func requestAuthorization(_ authType: String) {
        apiCall { openpath in
            openpath.requestAuthorization(authType)
        }
    }

    @objc(unlock:itemId:requestId:timeout:)
    func unlock(itemType: String, itemId: Int, requestId: Int, timeout: Int) {
        apiCall { openpath in
            openpath.unlock(itemType: itemType, itemId: itemId, requestId: requestId, timeout: timeout)
        }
    }

    @objc
    func refreshItemState(_ itemType: String, itemId: Int) {
        apiCall { openpath in
            openpath.refreshItemState(itemType: itemType, itemId: itemId)
        }
    }

    @objc
    func getSdkVersion(_ resolve: @escaping RCTPromiseResolveBlock, reject _: RCTPromiseRejectBlock) {
        apiCall { openpath in
            // This code takes the untyped dictionary that `getSdkVersion` returns and extracts
            // value["data"]["sdkVersion"], which will be just a string.
            let result = ResultMessage(message: openpath.getSdkVersion())?.successResult ?? ""
            resolve(result)
        }
    }

    @objc
    func getAuthorizationStatuses(_ resolve: @escaping RCTPromiseResolveBlock, reject _: RCTPromiseRejectBlock) {
        apiCall { openpath in
            // This code takes the untyped dictionary that `getAuthorizationStatuses` returns and extracts
            // value["data"]["authorizationStatuses"], which will be an array like:
            // [
            //   {
            //     "authType": String,
            //     "status": Int,
            //   }
            // ]
            let result = ResultMessage(message: openpath.getAuthorizationStatuses())?.successResult ?? []
            resolve(result)
        }
    }

    @objc
    func getUserApiToken(_ userOpal: String, resolve: @escaping RCTPromiseResolveBlock, reject _: RCTPromiseRejectBlock) {
        apiCall { openpath in
            let message = openpath.getUserApiToken(userOpal: userOpal)
            resolve(message)
        }
    }

    @objc
    func getReadersInRange(
        _ rssiThreshold: Int,
        resolve: @escaping RCTPromiseResolveBlock,
        reject _: RCTPromiseRejectBlock
    ) {
        apiCall { openpath in
            let message = openpath.getReadersInRange(rssiThreshold: rssiThreshold)
            resolve(message)
        }
    }

    @objc
    func sendFeedback(_ subject: String, message: String, messageJson: String?) {
        apiCall { openpath in
            openpath.sendFeedback(subject: subject, message: message, messageJson: messageJson)
        }
    }

    // Notifications
    @objc
    func enableErrorNotificationsForItem(_ itemType: String, itemId: Int) {
        apiCall { openpath in
            openpath.enableErrorNotificationsForItem(enabled: true, itemType: itemType, itemId: itemId)
        }
    }

    @objc
    func disableErrorNotificationsForItem(_ itemType: String, itemId: Int) {
        apiCall { openpath in
            openpath.enableErrorNotificationsForItem(enabled: true, itemType: itemType, itemId: itemId)
        }
    }

    @objc
    func softRefresh() {
        apiCall { openpath in
            openpath.softRefresh()
        }
    }

    @objc
    func refreshUserSettings() {
        apiCall { openpath in
            openpath.refreshUserSettings()
        }
    }

    @objc
    func getErrors(_ resolve: @escaping RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
        apiCall { openpath in
            // This code takes the untyped dictionary that `getErrors` returns and extracts
            // value["data"]["errors"], which will be an array like:
            // [
            //   {
            //     "code": String,
            //     "message": String,
            //   }
            // ]
            let result = ResultMessage(message: openpath.getErrors())?.successResult ?? []
            resolve(result)
        }
    }

    /// Magically forward the event to the JavaScript layer
    func forward(_ message: [String: Any], from callback: String = #function) {
        let callbackName = String(callback.split(separator: ":")[1])
        let body: [String: Any] = ["type": callbackName, "content": message]
        dispatch(body)
    }

    // MARK: OpenpathMobileAccessCore Delegate Methods

    public func openpathMobileAccessCore(_: OpenpathMobileAccessCore, onSyncUserResponse message: [String: Any]) {
        forward(message)
    }

    public func openpathMobileAccessCore(_: OpenpathMobileAccessCore, onSwitchUserResponse message: [String: Any]) {
        forward(message)
    }

    public func openpathMobileAccessCore(_: OpenpathMobileAccessCore, onProvisionResponse message: [String: Any]) {
        forward(message)
    }

    public func openpathMobileAccessCore(_: OpenpathMobileAccessCore, onUnprovisionResponse message: [String: Any]) {
        forward(message)
    }

    public func openpathMobileAccessCore(_: OpenpathMobileAccessCore, onUnlockResponse message: [String: Any]) {
        forward(message)
    }

    public func openpathMobileAccessCore(_: OpenpathMobileAccessCore, onOverrideResponse message: [String: Any]) {
        forward(message)
    }

    public func openpathMobileAccessCore(
        _: OpenpathMobileAccessCore,
        onTriggerLockdownPlanResponse message: [String: Any]
    ) {
        forward(message)
    }

    public func openpathMobileAccessCore(
        _: OpenpathMobileAccessCore,
        onRevertLockdownPlanResponse message: [String: Any]
    ) {
        forward(message)
    }

    public func openpathMobileAccessCore(_: OpenpathMobileAccessCore, onBluetoothStatusChanged message: [String: Any]) {
        forward(message)
    }

    public func openpathMobileAccessCore(_: OpenpathMobileAccessCore, onInternetStatusChanged message: [String: Any]) {
        forward(message)
    }

    public func openpathMobileAccessCore(_: OpenpathMobileAccessCore, onLocationStatusChanged message: [String: Any]) {
        forward(message)
    }

    public func openpathMobileAccessCore(
        _: OpenpathMobileAccessCore,
        onNotificationStatusChanged message: [String: Any]
    ) {
        forward(message)
    }

    public func openpathMobileAccessCore(_: OpenpathMobileAccessCore,
                                         onMicrophoneStatusChanged message: [String: Any]) {
        forward(message)
    }

    public func openpathMobileAccessCore(_: OpenpathMobileAccessCore, onMotionStatusChanged message: [String: Any]) {
        forward(message)
    }

    public func openpathMobileAccessCore(_: OpenpathMobileAccessCore, onUserSettingsSet message: [String: Any]) {
        forward(message)
    }

    public func openpathMobileAccessCore(_: OpenpathMobileAccessCore, onLockdownPlansSet message: [String: Any]) {
        forward(message)
    }

    public func openpathMobileAccessCore(_: OpenpathMobileAccessCore, onItemsSet message: [String: Any]) {
        forward(message)
    }

    public func openpathMobileAccessCore(_: OpenpathMobileAccessCore, onItemsUpdated message: [String: Any]) {
        forward(message)
    }

    public func openpathMobileAccessCore(_: OpenpathMobileAccessCore, onItemStatesUpdated message: [String: Any]) {
        forward(message)
    }

    // Openpath app (internal use) only
    public func openpathMobileAccessCore(_: OpenpathMobileAccessCore, onRevertResponse message: [String: Any]) {
        forward(message)
    }

    public func openpathMobileAccessCore(_: OpenpathMobileAccessCore, onSendFeedbackResponse message: [String: Any]) {
        forward(message)
    }

    public func openpathMobileAccessCore(_: OpenpathMobileAccessCore, onSendFeedbackRequest message: [String: Any]) {
        forward(message)
    }

    public func openpathMobileAccessCore(
        _: OpenpathMobileAccessCore,
        onRevertByConnectionTypeResponse message: [String: Any]
    ) {
        forward(message)
    }

    public func openpathMobileAccessCore(_: OpenpathMobileAccessCore, onDebug message: [String: Any]) {
        forward(message)
    }

    public func openpathMobileAccessCore(
        _: OpenpathMobileAccessCore,
        onUnlockByConnectionTypeResponse message: [String: Any]
    ) {
        forward(message)
    }

    public func openpathMobileAccessCore(_: OpenpathMobileAccessCore, onUnlockRequest message: [String: Any]) {
        forward(message)
    }

    public func openpathMobileAccessCore(_: OpenpathMobileAccessCore, onCredentialConfigSet message: [String: Any]) {
        forward(message)
    }

    public func openpathMobileAccessCore(_: OpenpathMobileAccessCore, onInitializeUserRequest message: [String: Any]) {
        forward(message)
    }

    public func openpathMobileAccessCore(
        _: OpenpathMobileAccessCore,
        onProtectedDataStatusChanged message: [String: Any]
    ) {
        forward(message)
    }

    private func logout(content: Any?) {
        if hasListeners {
            var body: [String: Any] = ["type": "logout"]
            body["content"] = content
            dispatch(body)
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { self.logout(content: content) }
        }
    }

    private func appUpdatePaused(content: Any?) {
        if hasListeners {
            let identifier = "openpathUpgrade"
            let title = "Aviligon Alta Upgrade"
            let body = "Aviligon Alta has upgraded. Tap here to finish the update."
            // send a notification
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = UNNotificationSound.default
            content.badge = 0

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { self.appUpdatePaused(content: content) }
        }
    }

    func openpathMobileAccessCore(_: OpenpathMobileAccessCore, onLogoutRequest message: [String: Any]) {
        if let type = message["type"] as? String, type == "logout" { logout(content: message["content"]) } else { dispatch(message) }
    }

    public func openpathMobileAccessCore(_: OpenpathMobileAccessCore, onAppUpdatePaused message: [String: Any]) {
        if let type = message["type"] as? String,
           type == "appUpdatePaused" { appUpdatePaused(content: message["content"]) } else { dispatch(message) }
    }

    // MARK: Helpers

    // send message up to Javascript
    public func dispatch(_ body: [String: Any]) {
        if hasListeners {
//            let strBody = JSON.stringify(value: body as AnyObject)
            sendEvent(withName: "OpenpathEvent", body: body)
        }
    }
}
