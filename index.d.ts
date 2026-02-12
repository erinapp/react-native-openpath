/**
 ## Adding the SDK to your project

 **NOTE:** First follow the steps to add the iOS and Android SDKs (documented separately).

 We provide the React Native SDK in a `.zip` file. To get started:

 * Unzip it into a known location
 * From the root of your React Native project, run the following command:
 ```
 yarn add file:</path/to/the/sdk>
 ```
 filling in the actual path to the extracted `.zip` file.

 ## For iOS, change these settings in your `ios/Podfile`:

 * Disable Flipper (if applicable)
 * Enable dynamic frameworks. (The exact method to do so depends on your React Native version and installation.)

 ## Usage

 ```javascript
 import * as ReactNativeOpenpath from 'react-native-openpath';

 // ...
 ReactNativeOpenpath.init(); // Call this once at startup.
 // ...
 ReactNativeOpenpath.provision(setupMobileToken);
 // etc..
 ```

 ### Subscribing to events

 ```javascript
 subscription = ReactNativeOpenpath.OpenpathEventEmitter.addListener(
 'OpenpathEvent',
 callback,
 );
 ```

 Refer to the reference documentation below for the available functions and events.


 > **Please note:** Although many of the code examples are in Typescript, you may use either JavaScript or Typescript to build your app.

 ------------------

 # React Native Sample App

 The React Native Sample App uses the Openpath Mobile Access Core SDK to:

 - Provision one or more user mobile credentials onto the app
 - Switch between users on the app
 - View the list of entries that the user has access to
 - Unlock an entry
 - Unprovision all the users or select one to unprovision from the list of inactive users

 For the purposes of this demo, we allow provisioning two different ways.

 1. The app can be provisioned via email and password, allowing a user to log in and generate their own mobile setup token to use for provisioning. Usually, only a user with admin rights to the Openpath Control Center (admin portal) has a password.

 2. The app can be provisioned via mobile setup token. In practice, most users won't have an Openpath password. We recommend that you create a service user (super admin) in the Openpath Control Center, and use that service user in your cloud to make Openpath API calls to generate a temporary mobile setup token for a particular user's mobile credential. Then this token should be passed from your cloud server to the mobile app and into the "provision" SDK function.

 For more information on the provisioning workflow, please refer to the Openpath Mobile Access SDK README section entitled "Provisioning Workflow".

 ## Building the Sample App

 The `reactNativeSampleApp` uses React Native version 0.79.2, which requires Node.js version 18 or higher. We recommend using [nodenv](https://github.com/nodenv/nodenv) to manage multiple Node.js versions. You may need to run `npm install -g yarn` after installing the required Node.js version.

 For both platforms:

 * Copy the iOS and/or Android SDK release into a location where the sample app can find it.
 * Run `yarn` in the root directory of the sample app.


 ### iOS

 * Update `ios/Podfile` to point to the directory where "OpenpathMobile.podspec" (and "OpenpathMobileAllegion.podspec" if you want AllegionSupport) is located
 * Ensure you have Ruby version 3.3.5 or greater. We recommend using [rbenv](https://github.com/rbenv/rbenv) to manage multiple Ruby versions.
 * Run `bundle install` in the root directory
 * Run `bundle exec pod install` in the `ios` directory.

 ### Android

 * Copy `openpath-sdk` directory from the Native Android SDK release directory into the `reactNativeSample/android` directory.

 ***
 # Release Notes

 [[include: react-native-release-v1.1.4.md]]
 [[include: react-native-release-v1.1.3.md]]
 [[include: react-native-release-v1.1.2.md]]
 [[include: react-native-release-v1.1.1.md]]
 [[include: react-native-release-v1.1.0.md]]
 [[include: react-native-release-v1.0.0.md]]
 @module react-native-openpath
 */

/** Imports */
import {NativeEventEmitter} from "react-native";
import {ProvisionResponse} from "./types/Events/ProvisionResponse";
import {SwitchUserResponse} from "./types/Events/SwitchUserResponse";
import {SyncUserResponse} from "./types/Events/SyncUserResponse";
import {UnlockResponse} from "./types/Events/UnlockResponse";
import {UnprovisionResponse} from "./types/Events/UnprovisionResponse";
import {InternetStatusChanged} from "./types/Events/InternetStatusChanged";
import {ItemStatesUpdated} from "./types/Events/ItemStatesUpdated";
import {ItemsSet} from "./types/Events/ItemsSet";
import {ItemsUpdated} from "./types/Events/ItemsUpdated";
import {BluetoothStatusChanged} from "./types/Events/BluetoothStatusChanged";
import {LocationStatusChanged} from "./types/Events/LocationStatusChanged";
import {ItemType} from "./types/Models/ItemType";
import {SendFeedbackResponse} from "./types/Events/SendFeedbackResponse";
import {MotionStatusChanged} from "./types/Events/MotionStatusChanged";
import {UserSettingsSet} from "./types/Events/UserSettingsSet";
import {OpenpathError} from "./types/Events/OpenpathError";
import {AuthorizationStatusType} from "./types/Models/AuthorizationStatus";

declare module 'react-native-openpath';

export * from "./types/Events/BluetoothStatusChanged";
export * from "./types/Events/InternetStatusChanged";
export * from "./types/Events/ItemStatesUpdated";
export * from "./types/Events/ItemsSet";
export * from "./types/Events/ItemsUpdated";
export * from "./types/Events/LocationStatusChanged";
export * from "./types/Events/MotionStatusChanged";
export * from "./types/Events/OpenpathError";
export * from "./types/Events/ProvisionResponse";
export * from "./types/Events/SendFeedbackResponse"
export * from "./types/Events/SwitchUserResponse";
export * from "./types/Events/SyncUserResponse";
export * from "./types/Events/UnlockResponse";
export * from "./types/Events/UnprovisionResponse";
export * from "./types/Events/UserSettingsSet";
export * from "./types/Models/AuthorizationStatus"
export * from "./types/Models/Camera";
export * from "./types/Models/Credential"
export * from "./types/Models/CredentialMobile"
export * from "./types/Models/GetErrorsResponse";
export * from "./types/Models/InData";
export * from "./types/Models/Item";
export * from "./types/Models/ItemType";
export * from "./types/Models/ReadersInRangeResponse";
export * from "./types/Models/User";

/**
 * Initializes the SDK. Call this once at startup
 */
export function init(): void;

/**
 * Provisions app with an Openpath user and saves their info and credentials for later use.
 *
 * Invokes `onProvisionResponse` on completion.
 *
 * @param setupMobileToken a temporary token for a specific user and credential (obtained from the
 * `generateSetupMobileToken` Openpath REST API)
 *
 * **NOTE**: This function does not start Openpath services, and this user is not active until {@link switchUser} and
 * {@link syncUser} are called.
 *
 * **NOTE II**: On iOS, this function must be called with the app in the foreground or at least in a state where the app
 * protected data (e.g., keychain and UserDefaults) is available. More on protected data here:
 * https://developer.apple.com/documentation/uikit/protecting_the_user_s_privacy/encrypting_your_app_s_files
 */
export function provision(setupMobileToken: string): void;

/**
 * Clears the Openpath user data for the requested user. If the app has multiple users provisioned, the requested user
 * can not be the active user. If no user is provided, the SDK unprovisions all provisioned users in the app.
 *
 * Invokes `onUnprovisionResponse` on completion.
 *
 * @param userOpal The user opal of the user to unprovision, or `null` to unprovision all users.
 */
export function unprovision(userOpal: string | null): void;

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
 * @param userOpal The user opal of the user to switch to.
 */
export function switchUser(userOpal: string): void;

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
 *   information.
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
export function syncUser(): void;

/**
 Request a refresh of controller configurations (e.g., entry and reader settings) and user entry permissions from the
 cloud.

 If successful and there are changes to report, one or more of the following will be invoked:
 - `onItemsSet`
 - `onItemStatesUpdated`
 - `onItemsUpdated`
 */
export function softRefresh(): void;

export type AuthType = 'location' | 'motion' | 'bluetooth' | 'notification' | 'background_location';

export type GetAuthorizationStatusesResponse = Array<{
    authType: AuthType,
    status: AuthorizationStatusType
}>;

/**
 * Get a list of statuses for authorization permissions.
 */
export function getAuthorizationStatuses(): Promise<GetAuthorizationStatusesResponse>;

/**
 * Requests permission for a system service.
 *
 * @param authType system service to request authorization for.
 */
export function requestAuthorization(authType: AuthType): void;

/**
 * Request a refresh of user data (cloud keys, whether user has remote or override unlock, etc.) from the cloud.
 *
 * Invokes `onUserSettingsSet` on completion.
 */
export function refreshUserSettings(): void;

/**
 * Request the updated state for an item.
 *
 * Invokes `onItemStatesUpdated` on completion.
 *
 * @param itemType
 * @param itemId The ID of the entry or reader
 */
export function refreshItemState(itemType: ItemType, itemId: number): void;

/**
 * Unlock an entry or reader.
 *
 * Invokes `onUnlockResponse` on completion.
 *
 * @param itemType "entry" or "reader" ("reader" should only be used in elevator scenarios)
 * @param itemId entryId or readerId
 * @param requestId unique numeric 32-bit integer
 * @param timeout milliseconds to wait until the request returns a timeout error. Recommended value  8000-10000.
 */
export function unlock(itemType: ItemType, itemId: number, requestId: number, timeout: number): void;

/**
 * Retrieve the current SDK version.
 */
export function getSdkVersion(): Promise<string>;

/**
 * Get a collection of possible SDK errors, including the error code and message.
 */
export function getErrors(): Promise<
    Array<{
        code: string,
        message: string
    }>
>;

/**
 * Sends feedback and SDK logs via email to Openpath. This can be implemented if you need support from Openpath to help
 * troubleshoot issues. It should be used for development, testing and integration purposes only. Feedback is most
 * helpful when sent immediately after an issue has occurred.
 *
 * Invokes `onSendFeedbackResponse` on completion.
 *
 * @param subject the email title
 * @param message the email body. Please include as much information in the message as possible, such as a detailed
 * description of the issue experienced, entry, time of occurrence, steps to reproduce, or any app state stored on your
 * side that might help.
 * @param messageJson Optional json-formatted string with additional information.
 */
export function sendFeedback(subject: string, message: string, messageJson?: string): void;


/**
 * Get the specified user's Openpath REST API Token.
 */
export function getUserApiToken(userOpal: string): Promise<{
    data: Array<{
        apiToken: string
    }>
}>;

/**
 * Enables error notifications for an item (reader or entry).
 *
 * A user will receive a notification when an unlock fails. Error notifications are enabled by default.
 *
 * @see disableErrorNotificationsForItem
 */
export function enableErrorNotificationsForItem(itemType: "entry" | "reader", itemId: number): void;

/**
 * Disables error notifications for an item (reader or entry).
 *
 * @see enableErrorNotificationsForItem
 */
export function disableErrorNotificationsForItem(itemType: "entry" | "reader", itemId: number): void;


/**
 * Get a collection of discovered readers in range sorted by RSSI values.
 *
 * The `rssiThreshold` parameter controls the sorting behavior.
 *
 * To reduce jitter, the list of readers is maintained in a semi-stable order. Since RSSI can vary considerably between
 * measurements, two entries will only swap places in the sorted list if the new top-sorted entry has an RSSI value that
 * is greater than the other entry's by at least `rssiThreshold`.
 */
export function getReadersInRange(rssiThreshold: number): Promise<{
    "data": {
        "readersInRange": [{
            "id": number,
            "name": string,
            "rssiValue": number
        }]
    }
}>;

/**
 * Enables or disables the foreground service (Android only).
 *
 * Running the foreground service will ensure that "wave to unlock" works reliably at all times whenever the user
 * approaches the reader. If the foreground service is disabled and the user has force-quit the app or the OS has closed
 * the app, the user will need to re-open the app in order for "wave to unlock" to work again.
 *
 * NOTE: On iOS, this performs no operation.
 */
export function setForegroundServiceEnabled(enabled: boolean): void;

/**
 * Fires an event of type {@link OpenpathEvent.}. That is, on success, the event will have the following shape:
 * ```typescript
 * {
 *     type: string, // The type of event, e.g., "onItemsUpdated"
 *     content: {
 *         data: T // Event-specific data. Documented in other places.
 *     }
 * }
 * ```
 */
export const OpenpathEventEmitter: NativeEventEmitter;

/**
 * The shape of messages passed to the {@link OpenpathEventEmitter}.
 *
 * "type" tells the type of event. "content" will either hold "data" or an "error".
 */
export type OpenpathEventMessage<T extends string, D> = {
    type: T;
    content: { data: D } | { err: OpenpathError };
};

/// Some OpenpathEvent shapes. Note that there are more of these, but this app doesn't support them yet.
export type OpenpathEvent =
    | OpenpathEventMessage<'onBluetoothStatusChanged', BluetoothStatusChanged>
    | OpenpathEventMessage<'onDebug', { message: string }>
    | OpenpathEventMessage<'onInternetStatusChanged', InternetStatusChanged>
    | OpenpathEventMessage<'onItemStatesUpdated', ItemStatesUpdated>
    | OpenpathEventMessage<'onItemsSet', ItemsSet>
    | OpenpathEventMessage<'onItemsUpdated', ItemsUpdated>
    | OpenpathEventMessage<'onMotionStatusChanged', MotionStatusChanged>
    | OpenpathEventMessage<'onLocationStatusChanged', LocationStatusChanged>
    | OpenpathEventMessage<'onProvisionResponse', ProvisionResponse>
    | OpenpathEventMessage<'onSendFeedbackResponse', SendFeedbackResponse>
    | OpenpathEventMessage<'onSwitchUserResponse', SwitchUserResponse>
    | OpenpathEventMessage<'onSyncUserResponse', SyncUserResponse>
    | OpenpathEventMessage<'onUnlockResponse', UnlockResponse>
    | OpenpathEventMessage<'onUnprovisionResponse', UnprovisionResponse>
    | OpenpathEventMessage<'onUserSettingsSet', UserSettingsSet>;
export {OpenpathLoginCancelledError} from "./types/Events/OpenpathLoginCancelledError";
