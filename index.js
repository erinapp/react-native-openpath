import ReactNative, { NativeModules, Platform } from 'react-native';

const { ReactNativeOpenpath } = NativeModules;
const isIos = Platform.OS === 'ios';

export const OpenpathEventEmitter = new ReactNative.NativeEventEmitter(ReactNativeOpenpath);

/**
 * Initializes the SDK. Call this once at startup.
 */
export function init() {
  if (Platform.OS === 'android') {
    ReactNativeOpenpath.init();
  }
}

/**
 * Provisions app with an Openpath user and saves their info and credentials for later use.
 *
 * Invokes `onProvisionResponse` on completion.
 *
 * @param {string} setupMobileToken a temporary token for a specific user and credential (obtained from the
 * `generateSetupMobileToken` Openpath REST API)
 *
 * **NOTE**: This function does not start Openpath services, and this user is not active until {@link switchUser} and
 * {@link syncUser} are called.
 *
 * **NOTE II**: On iOS, this function must be called with the app in the foreground or at least in a state where the app
 * protected data (e.g., keychain and UserDefaults) is available. More on protected data here:
 * https://developer.apple.com/documentation/uikit/protecting_the_user_s_privacy/encrypting_your_app_s_files
 */
export function provision(setupMobileToken) {
  return ReactNativeOpenpath.provision(setupMobileToken);
}

/**
 * Clears the Openpath user data for the requested user. If the app has multiple users provisioned, the requested user
 * can not be the active user. If no user is provided, the SDK unprovisions all provisioned users in the app.
 *
 * Invokes `onUnprovisionResponse` on completion.
 *
 * @param userOpal {string|null} The user opal of the user to unprovision, or `null` to unprovision all users.
 */
export function unprovision(userOpal) {
  if (userOpal) {
    return ReactNativeOpenpath.unprovision(userOpal);
  }

  // Android will crash if you do not pass in an argument to unprovision(). Just pass in null to log out of all users
  return ReactNativeOpenpath.unprovision(null);
}

/**
 * Switch to another provisioned user.
 *
 * Stops services of the current user if it is different from the required one, then loads the info of the required user
 * from the stored records and restarts Openpath services for the new user.
 *
 * This method should be called right after a successful provision response, or in order to switch to another user that
 * was provisioned previously in the system. A successful return of this call should be always followed by a call to
 * {@link syncUser}.
 *
 * Invokes `onSwitchUserResponse` on completion.
 *
 * @param {string} userOpal The user opal of the user to switch to.
 */
export function switchUser(userOpal) {
  return ReactNativeOpenpath.switchUser(userOpal);
}

/**
 * Syncs the active user.
 *
 * This function:
 *
 * - Broadcasts (through `ReactNativeOpenpath.OpenpathEventEmitter`) the following:
 *     * The current accessibility status of Bluetooth, Location, and internet services
 *     * The user's items (entries/readers);
 *     * The user's settings.
 * - Then invokes `onSyncUserResponse` in the event emitter with the latest/updated user information and app version
 * information.
 *
 * Within `onSyncUserResponse`, the only SDK-relevant fields in the "appVersion" section are "latestSdkVersion" and
 * "deprecatedSdkVersion". If you'd like to gracefully handle the situation where the app has a deprecated SDK version,
 * you can compare the "deprecatedSdkVersion" field with the current app's SDK version by calling `getSdkVersion`.
 *
 * This function should be called right after a successful return of a call to {@link switchUser}. It should also be
 * called when the app first opens to retrieve the latest current user information.
 *
 * Invokes `onSyncUserResponse` on completion.
 */
export function syncUser() {
  return ReactNativeOpenpath.syncUser();
}

/**
 * Request a refresh of controller configurations (e.g., entry and reader settings) and user entry permissions from the
 * cloud.

 * If successful and there are changes to report, one or more of the following will be invoked:
 * - `onItemsSet`
 * - `onItemStatesUpdated`
 * - `onItemsUpdated`
 */
export function softRefresh() {
  ReactNativeOpenpath.softRefresh();
}

/**
 * Get a list of statuses for authorization permissions.
 */
export function getAuthorizationStatuses() {
  return ReactNativeOpenpath.getAuthorizationStatuses();
}

/**
 * Requests permission for a system service.
 *
 * @param {'location' | 'motion' | 'bluetooth' | 'notification'} authType system service to request authorization for.
 */
export function requestAuthorization(authType) {
  ReactNativeOpenpath.requestAuthorization(authType);
}

/**
 * Request a refresh of user data (cloud keys, whether user has remote or override unlock, etc.) from the cloud.
 *
 * Invokes `onUserSettingsSet` on completion.
 */
export function refreshUserSettings() {
  return ReactNativeOpenpath.refreshUserSettings();
}

/**
 * Request the updated state for an item.
 *
 * Invokes `onItemStatesUpdated` on completion.
 *
 * @param {'entry'|'reader'} itemType
 * @param {number} itemId
 */
export function refreshItemState(itemType, itemId) {
  ReactNativeOpenpath.refreshItemState(itemType, itemId);
}

/**
 * Unlock an entry or reader.
 *
 * Invokes `onUnlockResponse` on completion.
 *
 * @param {'entry'|'reader'} itemType
 * @param {number} itemId
 * @param {number} requestId
 * @param {number} timeout
 */
export function unlock(itemType, itemId, requestId, timeout) {
  ReactNativeOpenpath.unlock(itemType, itemId, requestId, timeout);
}

/**
 * Retrieve the current SDK version.
 */
export function getSdkVersion() {
  return ReactNativeOpenpath.getSdkVersion();
}

/**
 * Get a collection of possible SDK errors, including the error code and message.
 */
export function getErrors() {
  return ReactNativeOpenpath.getErrors();
}

/**
 * Get the specified user's Openpath REST API Token.
 *
 * @param {string} userOpal
 */
export function getUserApiToken(userOpal) {
  return ReactNativeOpenpath.getUserApiToken(userOpal);
}

/**
 * Enables error notifications for an item (reader or entry).
 *
 * A user will receive a notification when an unlock fails. Error notifications are enabled by default.
 *
 * @param {'entry'|'reader'} itemType
 * @param {number} itemId
 */
export function enableErrorNotificationsForItem(itemType, itemId) {
  ReactNativeOpenpath.enableErrorNotificationsForItem(itemType, itemId);
}

/**
 * Disables error notifications for an item (reader or entry).
 *
 * @param {'entry'|'reader'} itemType
 * @param {number} itemId
 */
export function disableErrorNotificationsForItem(itemType, itemId) {
  ReactNativeOpenpath.disableErrorNotificationsForItem(itemType, itemId);
}

/**
 * Sends feedback and SDK logs via email to Openpath. This can be implemented if you need support from Openpath to help
 * troubleshoot issues. It should be used for development, testing and integration purposes only. Feedback is most
 * helpful when sent immediately after an issue has occurred.
 *
 * Invokes `onSendFeedbackResponse` on completion.
 *
 * @param {string} subject the email title
 * @param {string} message the email body. Please include as much information in the message as possible, such as a
 * detailed description of the issue experienced, entry, time of occurrence, steps to reproduce, or any app state stored
 * on your side that might help.
 * @param {String} messageJson Optional json-formatted string with additional information.
 */
export function sendFeedback(subject, message, messageJson) {
  return ReactNativeOpenpath.sendFeedback(subject, message, messageJson);
}

/**
 * Get a collection of discovered readers in range sorted by RSSI values, in a promise.
 *
 * The `rssiThreshold` parameter controls the sorting behavior.
 *
 * To reduce jitter, the list of readers is maintained in a semi-stable order. Since RSSI can vary considerably between
 * measurements, two entries will only swap places in the sorted list if the new top-sorted entry has an RSSI value that
 * is greater than the other entry's by at least `rssiThreshold`.
 */
export function getReadersInRange() {
  try {
    if (isIos) {
      return ReactNativeOpenpath.getReadersInRange(6);
    }
    return ReactNativeOpenpath.getReadersInRange();
  } catch (error) {
    return null;
  }
}

/**
 * Enables or disables the foreground service (Android only).
 *
 * Running the foreground service will ensure that "wave to unlock" works reliably at all times whenever the user
 * approaches the reader. If the foreground service is disabled and the user has force-quit the app or the OS has closed
 * the app, the user will need to re-open the app in order for "wave to unlock" to work again.
 *
 * NOTE: On iOS, this performs no operation.
 */
export function setForegroundServiceEnabled(enabled) {
  if (Platform.OS === 'android') {
    ReactNativeOpenpath.setForegroundServiceEnabled(enabled);
  }
}
