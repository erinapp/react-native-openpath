
package com.openpath;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.util.Log;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.openpath.mobileaccesscore.OpenpathAudioDeviceStatus;
import com.openpath.mobileaccesscore.OpenpathAuthorizationStatus;
import com.openpath.mobileaccesscore.OpenpathBluetoothStatus;
import com.openpath.mobileaccesscore.OpenpathCamera;
import com.openpath.mobileaccesscore.OpenpathItem;
import com.openpath.mobileaccesscore.OpenpathItemState;
import com.openpath.mobileaccesscore.OpenpathLocationStatus;
import com.openpath.mobileaccesscore.OpenpathLockdownPlan;
import com.openpath.mobileaccesscore.OpenpathLogging;
import com.openpath.mobileaccesscore.OpenpathMobileAccessCore;
import com.openpath.mobileaccesscore.OpenpathNotificationStatus;
import com.openpath.mobileaccesscore.OpenpathOrderingItem;
import com.openpath.mobileaccesscore.OpenpathProvisionResponse;
import com.openpath.mobileaccesscore.OpenpathReader;
import com.openpath.mobileaccesscore.OpenpathRequestResponse;
import com.openpath.mobileaccesscore.OpenpathResponse;
import com.openpath.mobileaccesscore.OpenpathServiceException;
import com.openpath.mobileaccesscore.OpenpathSoundStatus;
import com.openpath.mobileaccesscore.OpenpathSwitchUserResponse;
import com.openpath.mobileaccesscore.OpenpathSyncUserResponse;
import com.openpath.mobileaccesscore.OpenpathUnprovisionResponse;
import com.openpath.mobileaccesscore.OpenpathUserSettings;
import com.openpath.mobileaccesscore.helium.AllegionMobile;
import com.openpath.mobileaccesscore.helium.CloudKey;
import com.openpath.mobileaccesscore.helium.CredentialAction;
import com.openpath.mobileaccesscore.helium.CredentialConfig;
import com.openpath.mobileaccesscore.helium.User;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.TimeZone;

import javax.annotation.Nullable;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;


public class ReactNativeOpenpathModule extends ReactContextBaseJavaModule {

    private final static String TAG = "ReactNativeOpenpath";
    private final ReactApplicationContext reactContext;

    public ReactNativeOpenpathModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @NonNull
    @Override
    public String getName() {
        return "ReactNativeOpenpath";
    }

    @ReactMethod
    public void addListener(String eventName) {
        // Set up any upstream listeners or background tasks as necessary
        // Required as of react-native@65.0
        // Source: https://reactnative.dev/docs/native-modules-android
        Log.d(TAG, String.format("addListener %s", eventName));
    }

    @ReactMethod
    public void removeListeners(Integer count) {
        // Remove upstream listeners, stop unnecessary background tasks
        // Required as of react-native@65.0
        // Source: https://reactnative.dev/docs/native-modules-android
        Log.d(TAG, "removeListeners");
    }


    @ReactMethod
    public void init() {
        Log.v(TAG, "native module init");

        Activity activity = reactContext.getCurrentActivity();
        if (activity != null) {
            activity.runOnUiThread(() -> {
                OpenpathMobileAccessCore.getInstance().init(activity.getApplication(), mOpenpathEventHandler);
            });
        }
    }

    @ReactMethod
    public void requestAuthorization(String type) {
        OpenpathMobileAccessCore.getInstance().requestAuthorization(getReactApplicationContext().getCurrentActivity(), type);
    }

    @ReactMethod
    public void enableErrorNotificationsForItem(String itemType, int itemId, Promise promise) {
        OpenpathMobileAccessCore.getInstance().enableErrorNotificationsForItem(true, itemType, itemId);
        promise.resolve(null);
    }

    @ReactMethod
    public void disableErrorNotificationsForItem(String itemType, int itemId, Promise promise) {
        OpenpathMobileAccessCore.getInstance().enableErrorNotificationsForItem(false, itemType, itemId);
        promise.resolve(null);
    }

    @ReactMethod
    public void getUserApiToken(String userOpal, Promise promise) {
        try {
            promise.resolve(OpenpathMobileAccessCore.getInstance().getUserApiToken(userOpal));
        } catch (BadPaddingException | IllegalBlockSizeException | CertificateException | NoSuchAlgorithmException | NoSuchProviderException | KeyStoreException | IOException | UnrecoverableKeyException | NoSuchPaddingException | InvalidKeyException | InvalidAlgorithmParameterException | OpenpathServiceException e) {
            promise.reject("error loading user api token", e);
        }
    }

    @ReactMethod
    public void unlock(String itemType, int itemId, int requestId, int timeout) {
        OpenpathMobileAccessCore.getInstance().unlock(itemType, itemId, requestId, timeout);
    }

    @ReactMethod
    public void getReadersInRange(Promise promise) {
        ArrayList<OpenpathReader> readers = OpenpathMobileAccessCore.getInstance().getReadersInRange(6);

        // resolving WritableMap works only if WritableArray is created in separate function. Otherwise dataMap.putArray causes exception
        try {
            WritableMap dataMap = Arguments.createMap();
            dataMap.putArray("data", getReadersArray(readers));
            promise.resolve(dataMap);
        } catch (Exception ex) {
            OpenpathLogging.e("error getting readers in range", ex);
            promise.reject("error getting readers in range", ex);
        }
    }

    /// Source: https://gist.github.com/viperwarp/2beb6bbefcc268dee7ad
    private static WritableMap convertJsonToMap(@Nullable JSONObject jsonObject) throws JSONException {
        if (jsonObject == null) {
            throw new JSONException("Null JSON object");
        }
        WritableMap map = new WritableNativeMap();

        Iterator<String> iterator = jsonObject.keys();
        while (iterator.hasNext()) {
            String key = iterator.next();
            Object value = jsonObject.get(key);
            if (value instanceof JSONObject) {
                map.putMap(key, convertJsonToMap((JSONObject) value));
            } else if (value instanceof  JSONArray) {
                map.putArray(key, convertJsonToArray((JSONArray) value));
            } else if (value instanceof  Boolean) {
                map.putBoolean(key, (Boolean) value);
            } else if (value instanceof  Integer) {
                map.putInt(key, (Integer) value);
            } else if (value instanceof  Double) {
                map.putDouble(key, (Double) value);
            } else if (value instanceof String)  {
                map.putString(key, (String) value);
            } else {
                map.putString(key, value.toString());
            }
        }
        return map;
    }

    /// Source: https://gist.github.com/viperwarp/2beb6bbefcc268dee7ad
    private static WritableArray convertJsonToArray(JSONArray jsonArray) throws JSONException {
        WritableArray array = new WritableNativeArray();

        for (int i = 0; i < jsonArray.length(); i++) {
            Object value = jsonArray.get(i);
            if (value instanceof JSONObject) {
                array.pushMap(convertJsonToMap((JSONObject) value));
            } else if (value instanceof  JSONArray) {
                array.pushArray(convertJsonToArray((JSONArray) value));
            } else if (value instanceof  Boolean) {
                array.pushBoolean((Boolean) value);
            } else if (value instanceof  Integer) {
                array.pushInt((Integer) value);
            } else if (value instanceof  Double) {
                array.pushDouble((Double) value);
            } else if (value instanceof String)  {
                array.pushString((String) value);
            } else {
                array.pushString(value.toString());
            }
        }
        return array;
    }

    private WritableArray getReadersArray(ArrayList<OpenpathReader> readers) {
        WritableArray nativeArray = Arguments.createArray();
        for (OpenpathReader openpathReader : readers) {
            WritableMap writableMap = Arguments.createMap();
            writableMap.putInt("id", openpathReader.id);
            writableMap.putString("name", openpathReader.name);
            writableMap.putInt("avgBleRssi", openpathReader.averageRssi);
            nativeArray.pushMap(writableMap);
        }
        return nativeArray;
    }

    @ReactMethod
    public void provision(String setupMobileToken, Promise promise) {
        OpenpathMobileAccessCore.getInstance().provision("Openpath Mobile Access", setupMobileToken);
        promise.resolve(null);
    }

    @ReactMethod
    public void switchUser(String userOpal, Promise promise) {
        OpenpathMobileAccessCore.getInstance().switchUser(userOpal);
        promise.resolve(null);
    }

    @ReactMethod
    public void syncUser(Promise promise) {
        OpenpathMobileAccessCore.getInstance().syncUser();
        promise.resolve(null);
    }

    @ReactMethod
    public void sendFeedback(String subject, String message, String messageJson, Promise promise) {
        OpenpathMobileAccessCore.getInstance().sendFeedback(subject, message, messageJson);
        promise.resolve(null);
    }

    @ReactMethod
    public void unprovision(String userOpal, Promise promise) {
        OpenpathMobileAccessCore.getInstance().unprovision(userOpal);
        promise.resolve(null);
    }

    @ReactMethod
    public void getAuthorizationStatuses(Promise promise) {
        ArrayList<OpenpathAuthorizationStatus> authorizationStatuses = OpenpathMobileAccessCore.getInstance().getAuthorizationStatuses();
        WritableArray result = Arguments.createArray();
        if(authorizationStatuses != null) {
            for (OpenpathAuthorizationStatus authorizationStatus : authorizationStatuses) {
                WritableMap map = Arguments.createMap();
                map.putString("authType", authorizationStatus.type);
                map.putInt("status", authorizationStatus.status);
                result.pushMap(map);
            }
        }
        promise.resolve(result);
    }

    @ReactMethod
    public void refreshItemState(String itemType, int itemId) {
        try {
            OpenpathMobileAccessCore.getInstance().refreshItemState(itemType, itemId);
        } catch (Exception ex) {
            OpenpathLogging.e("error refreshing item state", ex);
        }
    }

    @ReactMethod
    public void softRefresh() {
        OpenpathLogging.v("softRefresh");
        OpenpathMobileAccessCore.getInstance().softRefresh();
    }

    @ReactMethod
    public void refreshUserSettings() {
        try {
            OpenpathMobileAccessCore.getInstance().refreshUserSettings();
        } catch (Exception ex) {
            OpenpathLogging.e("error refreshing user settings", ex);
        }
    }

    @ReactMethod
    public void setForegroundServiceEnabled(Boolean enabled) {
        OpenpathMobileAccessCore.getInstance().setForegroundServiceEnabled(enabled);
    }

    private String parseDateToISOString(Date date) {
        try {
            @SuppressLint("SimpleDateFormat")
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
            TimeZone tz = TimeZone.getTimeZone("UTC");
            format.setTimeZone(tz);
            return format.format(date);
        } catch (Exception e) {
            return null;
        }
    }

    OpenpathMobileAccessCore.OpenpathEventHandler mOpenpathEventHandler = new OpenpathMobileAccessCore.OpenpathEventHandler() {
        private WritableMap userToJson(User user) {
            WritableMap userJson = Arguments.createMap();
            userJson.putInt("id", user.id);
            userJson.putString("opal", user.opal);
            userJson.putString("pictureUrl", user.pictureUrl);
            WritableMap identity = Arguments.createMap();
            identity.putInt("id", user.identity.id);
            identity.putString("opal", user.identity.opal);
            identity.putString("firstName", user.identity.firstName);
            identity.putString("middleName", user.identity.middleName);
            identity.putString("lastName", user.identity.lastName);
            identity.putString("fullName", user.identity.fullName);
            identity.putString("email", user.identity.email);
            userJson.putMap("identity", identity);
            WritableMap org = Arguments.createMap();
            org.putInt("id", user.org.id);
            org.putString("opal", user.org.opal);
            org.putString("name", user.org.name);
            org.putString("pictureUrl", user.org.pictureUrl);
            userJson.putMap("org", org);
            userJson.putString("status", user.status);
            userJson.putString("startDate", user.startDate != null ? parseDateToISOString(user.startDate) : null);
            userJson.putString("endDate", user.endDate != null ? parseDateToISOString(user.endDate) : null);
            return userJson;
        }

        private WritableMap itemToJson(OpenpathItem item) throws JSONException {
            WritableMap jsonItem = Arguments.createMap();
            jsonItem.putInt("acuId", item.acuId);
            jsonItem.putString("name", item.name);
            jsonItem.putString("orgName", item.orgName);
            jsonItem.putInt("itemId", item.id);
            jsonItem.putString("itemType", item.type);
            jsonItem.putBoolean("isInRange", item.isInRange);
            jsonItem.putBoolean("isAvailableInRange", item.isAvailableInRange);
            jsonItem.putBoolean("isAvailableNearbyNotification", item.isAvailableNearbyNotification);
            jsonItem.putBoolean("isAvailableOverrideUnlock", item.isAvailableOverrideUnlock);
            jsonItem.putString("color", item.color);
            jsonItem.putBoolean("isReadyToUnlock", item.isReadyToUnlock);
            WritableArray cameraIds = Arguments.createArray();
            for (int id : item.cameraIds) {
                cameraIds.pushInt(id);
            }
            jsonItem.putArray("cameraIds", cameraIds);
            WritableArray readerIds = Arguments.createArray();
            for (int id : item.readerIds) {
                readerIds.pushInt(id);
            }
            jsonItem.putArray("readerIds", readerIds);
            return jsonItem;
        }

        @Override
        public void onInit() {
            sendData(Arguments.createMap(), "onInit");
        }

        @Override
        public void onProvisionResponse(OpenpathProvisionResponse response) {
            try {
                String responseType = "onProvisionResponse";
                if (response.hasError()) {
                    sendError(response, responseType);
                } else {
                    WritableMap data = Arguments.createMap();
                    data.putString("userOpal", response.user.opal);
                    ReadableMap user = userToJson(response.user);
                    data.putMap("user", user);
                    WritableMap credential = Arguments.createMap();
                    credential.putInt("id", response.credential.id);
                    credential.putString("opal", response.credential.opal);
                    WritableMap credentialType = Arguments.createMap();
                    credentialType.putString("modelName", response.credential.credentialType.modelName);
                    credential.putMap("credentialType", credentialType);
                    WritableMap mobile = Arguments.createMap();
                    mobile.putInt("id", response.credential.mobile.id);
                    mobile.putString("name", response.credential.mobile.name);
                    mobile.putString("provisionedAt", response.credential.mobile.provisionedAt);

                    if (response.credential.mobile.allegionMobile != null) {
                        mobile.putMap("allegionMobile", convertJsonToMap(AllegionMobile.toJson(response.credential.mobile.allegionMobile)));
                    } else {
                        mobile.putNull("allegionMobile");
                    }
                    credential.putMap("mobile", mobile);
                    credential.putString("startDate", response.credential.startDate != null ? parseDateToISOString(response.credential.startDate) : null);
                    credential.putString("endDate", response.credential.endDate != null ? parseDateToISOString(response.credential.endDate) : null);
                    data.putMap("credential", credential);
                    WritableMap environment = Arguments.createMap();
                    environment.putString("heliumEndpoint", response.environment.heliumEndpoint);
                    environment.putString("opalEnv", response.environment.opalEnv);
                    environment.putString("opalRegion", response.environment.opalRegion);
                    data.putMap("environment", environment);
                    data.putInt("entryCount", response.entryCount);
                    sendData(data, responseType);
                }
            } catch (JSONException e) {
                OpenpathLogging.e("json error", e);
            }
        }

//    @Override
//    public void onStartResponse(OpenpathStartResponse response) {
//      WritableMap content = Arguments.createMap();
//      try {
//        if(response.hasError()) {
//          WritableMap err = Arguments.createMap();
//          err.putString("code", response.error.code);
//          err.putString("message", response.error.message);
//          content.putString("err", err);
//        } else {
//          WritableMap data = Arguments.createMap();
//          WritableMap user = userToJson(response.user);
//          data.putString("user", user);
//          if(response.appVersion != null) {
//            WritableMap appVersion = Arguments.createMap();
//            appVersion.putString("id", response.appVersion.id);
//            appVersion.putString("latestBuild", response.appVersion.latestBuild);
//            appVersion.putString("latestVersion", response.appVersion.latestVersion);
//            appVersion.putString("deprecatedBuild", response.appVersion.deprecatedBuild);
//            appVersion.putString("deprecatedVersion", response.appVersion.deprecatedVersion);
//            appVersion.putString("os", response.appVersion.os);
//            appVersion.putString("isUpdateRequired", response.appVersion.isUpdateRequired);
//            data.putString("appVersion", appVersion);
//          }
//          if(response.credentialActions != null) {
//            WritableArray credentialActions = Arguments.createArray();
//            for (CredentialAction action : response.credentialActions) {
//              WritableMap credentialAction = Arguments.createMap();
//              WritableMap credentialActionType = Arguments.createMap();
//              credentialActionType.putString("id", action.credentialActionType.id);
//              credentialActionType.putString("command", action.credentialActionType.command);
//              credentialActionType.putString("name", action.credentialActionType.name);
//              credentialAction.putString("credentialActionType", credentialActionType);
//              WritableMap requestedByIdentity = Arguments.createMap();
//              requestedByIdentity.putString("id", action.requestedByIdentity.id);
//              requestedByIdentity.putString("fullName", action.requestedByIdentity.fullName);
//              requestedByIdentity.putString("email", action.requestedByIdentity.email);
//              credentialAction.putString("requestedByIdentity", requestedByIdentity);
//              credentialAction.putString("id", action.id);
//              credentialAction.putString("reason", action.reason);
//              credentialAction.putString("expiresAt", action.expiresAt);
//              credentialAction.putString("requestedAt", action.requestedAt);
//              credentialActions.putString(credentialAction);
//            }
//            data.putString("credentialActions", credentialActions);
//          }
//          if(response.credentialConfig != null) {
//            WritableMap credentialConfigData = Arguments.createMap();
//            WritableMap credentialConfigContent = Arguments.createMap();
//            credentialConfigData.putString("isDeveloperToolsEnabled", response.credentialConfig.isDeveloperToolsEnabled);
//            credentialConfigData.putString("logLevel", response.credentialConfig.logLevel);
//            credentialConfigContent.putString("data", credentialConfigData);
//            WritableMap jsonMessage = Arguments.createMap();
//            jsonMessage.putString("type", "credentialConfigSet");
//            jsonMessage.putString("content", credentialConfigContent);
//            onEvent(jsonMessage);
//          }
//          data.putString("userOpal", response.user.opal);
//          content.putString("data", data);
//        }
//        WritableMap jsonMessage = Arguments.createMap();
//        jsonMessage.putString("type", "startResponse");
//        jsonMessage.putMap("content", content);
//        onEvent(jsonMessage);
//      } catch(JSONException e) {
//        OpenpathLogging.e("json error", e);
//      }
//    }


        @Override
        public void onSwitchUserResponse(OpenpathSwitchUserResponse response) {
            String responseType = "onSwitchUserResponse";
            if (response.hasError()) {
                sendError(response, responseType);
            } else {
                WritableMap content = Arguments.createMap();
                content.putString("userOpal", response.userOpal);
                sendData(content, responseType);
            }
        }

        @Override
        public void onSyncUserResponse(OpenpathSyncUserResponse response) {
            try {
                String responseType = "onSyncUserResponse";
                if (response.hasError()) {
                    sendError(response, responseType);
                } else {
                    WritableMap data = Arguments.createMap();
                    ReadableMap user = userToJson(response.user);

                    data.putMap("user", user);
                    if (response.appVersion != null) {
                        WritableMap appVersion = Arguments.createMap();
                        appVersion.putInt("id", response.appVersion.id);
                        appVersion.putInt("latestBuild", response.appVersion.latestBuild);
                        appVersion.putString("latestVersion", response.appVersion.latestVersion);
                        appVersion.putInt("deprecatedBuild", response.appVersion.deprecatedBuild);
                        appVersion.putString("deprecatedVersion", response.appVersion.deprecatedVersion);
                        appVersion.putString("os", response.appVersion.os);
                        appVersion.putBoolean("isUpdateRequired", response.appVersion.isUpdateRequired);
                        data.putMap("appVersion", appVersion);
                    }
                    if (response.credentialActions != null) {
                        WritableArray credentialActions = Arguments.createArray();
                        for (CredentialAction action : response.credentialActions) {
                            WritableMap credentialAction = Arguments.createMap();
                            WritableMap credentialActionType = Arguments.createMap();
                            credentialActionType.putInt("id", action.credentialActionType.id);
                            credentialActionType.putString("command", action.credentialActionType.command);
                            credentialActionType.putString("name", action.credentialActionType.name);
                            credentialAction.putMap("credentialActionType", credentialActionType);
                            WritableMap requestedByIdentity = Arguments.createMap();
                            requestedByIdentity.putInt("id", action.requestedByIdentity.id);
                            requestedByIdentity.putString("fullName", action.requestedByIdentity.fullName);
                            requestedByIdentity.putString("email", action.requestedByIdentity.email);
                            credentialAction.putMap("requestedByIdentity", requestedByIdentity);
                            credentialAction.putInt("id", action.id);
                            credentialAction.putString("reason", action.reason);
                            credentialAction.putString("expiresAt", action.expiresAt);
                            credentialAction.putString("requestedAt", action.requestedAt);
                            credentialActions.pushMap(credentialAction);
                        }
                        data.putArray("credentialActions", credentialActions);
                    }
                    if (response.credential != null) {
                        WritableMap credential = Arguments.createMap();
                        credential.putInt("id", response.credential.id);
                        credential.putString("opal", response.credential.opal);
                        WritableMap credentialType = Arguments.createMap();
                        credentialType.putString("modelName", response.credential.credentialType.modelName);
                        credential.putMap("credentialType", credentialType);
                        WritableMap mobile = Arguments.createMap();
                        mobile.putInt("id", response.credential.mobile.id);
                        mobile.putString("name", response.credential.mobile.name);
                        mobile.putString("provisionedAt", response.credential.mobile.provisionedAt);
                        JSONObject allegionJson = AllegionMobile.toJson(response.credential.mobile.allegionMobile);
                        if (allegionJson != null) {
                            mobile.putMap("allegionMobile", convertJsonToMap(allegionJson));
                        } else {
                            mobile.putNull("allegionMobile");
                        }
                        credential.putMap("mobile", mobile);
                        credential.putString("startDate", response.credential.startDate != null ? parseDateToISOString(response.credential.startDate) : null);
                        credential.putString("endDate", response.credential.endDate != null ? parseDateToISOString(response.credential.endDate) : null);
                        data.putMap("credential", credential);
                    }
                    if (response.credentialConfig != null) {
                        WritableMap credentialConfigData = convertJsonToMap(CredentialConfig.toJson(response.credentialConfig));
                        sendData(credentialConfigData, "onCredentialConfigSet");
                    }
                    data.putString("userOpal", response.user.opal);
                    sendData(data, responseType);
                }
            } catch (JSONException e) {
                OpenpathLogging.e("json error", e);
            }
        }

        @Override
        public void onFeedbackResponse(OpenpathResponse response) {
            String responseType = "onSendFeedbackResponse";
            if (response.hasError()) {
                sendError(response, responseType);
            } else {
                WritableMap content = Arguments.createMap();
                // Type name adjusted to match iOS:
                sendData(content, responseType);
            }
        }

        @Override
        public void onUnprovisionResponse(OpenpathUnprovisionResponse response) {
            String responseType = "onUnprovisionResponse";
            if (response.hasError()) {
                sendError(response, responseType);
            } else {
                WritableMap data = Arguments.createMap();
                data.putString("userOpal", response.userOpal);
                data.putInt("reasonCode", response.reasonCode);
                data.putString("reasonDescription", response.reasonDescription);
                sendData(data, responseType);
            }
        }

        @Override
        public void onUnlockResponse(OpenpathRequestResponse response) {
            WritableMap content = Arguments.fromBundle(response.toBundle());
            sendData(content, "onUnlockResponse");
        }

        @Override
        public void onRevertResponse(OpenpathRequestResponse response) {
            WritableMap content = Arguments.fromBundle(response.toBundle());
            sendData(content, "onRevertResponse");
        }

        @Override
        public void onOverrideResponse(OpenpathRequestResponse response) {
            WritableMap content = Arguments.fromBundle(response.toBundle());
            sendData(content, "onOverrideResponse");
        }

        @Override
        public void onTriggerLockdownPlanResponse(OpenpathRequestResponse response) {
            WritableMap content = Arguments.fromBundle(response.toBundle());
            sendData(content, "onTriggerLockdownPlanResponse");
        }

        @Override
        public void onRevertLockdownPlanResponse(OpenpathRequestResponse response) {
            WritableMap content = Arguments.fromBundle(response.toBundle());
            sendData(content, "onRevertLockdownPlanResponse");
        }

        @Override
        public void onItemUnlockRequest(String itemType, int itemId, String connectionType) {
            WritableMap content = Arguments.createMap();
            content.putString("itemType", itemType);
            content.putInt("itemId", itemId);
            content.putString("connectionType", connectionType);
            // NOTE: JS event name altered from Android event name to match iOS
            sendData(content, "onUnlockRequest");
        }

//    @Override
//    public void onWillStartUserOpal(String userOpal) {
//      try {
//        WritableMap content = Arguments.createMap();
//        content.putString("userOpal", userOpal);
//        WritableMap jsonMessage = Arguments.createMap();
//        jsonMessage.putString("type", "willStartUserOpal");
//        jsonMessage.putMap("content", content);
//        onEvent(jsonMessage);
//      } catch (JSONException e) {
//        OpenpathLogging.e("json error", e);
//      }
//    }

//        @Override
        public void onNotificationClicked(String itemType, int itemId) {
            WritableMap content = Arguments.createMap();
            content.putString("itemType", itemType);
            content.putInt("itemId", itemId);
            sendData(content, "onNotificationClicked");
        }

        @Override
        public void onNotificationActionClicked(String actionType) {
            WritableMap content = Arguments.createMap();
            content.putString("actionType", actionType);
            sendData(content, "onNotificationActionClicked");
        }

        @Override
        public void onBluetoothStatusChanged(OpenpathBluetoothStatus bluetoothStatus) {
            try {
                WritableMap content = convertJsonToMap(OpenpathBluetoothStatus.toJson(bluetoothStatus));
                sendData(content, "onBluetoothStatusChanged");
            } catch (JSONException e) {
                OpenpathLogging.e("json error", e);
            }
        }

        @Override
        public void onBluetoothError(OpenpathResponse response) {
            WritableMap content = Arguments.createMap();
            if (response.hasError()) {
                WritableMap error = Arguments.fromBundle(response.error.toBundle());
                content.putMap("error", error);
            }
            sendData(content, "onBluetoothError");
        }

        @Override
        public void onInternetStatusChanged(boolean internetConnected) {
            WritableMap content = Arguments.createMap();
            content.putBoolean("isInternetAvailable", internetConnected);
            sendData(content, "onInternetStatusChanged");
        }

        @Override
        public void onSoundStatusChanged(OpenpathSoundStatus soundStatus) {
            try {
                WritableMap content = convertJsonToMap(OpenpathSoundStatus.toJson(soundStatus));
                // NOTE: event name modified to match what iOS sends.
                sendData(content, "onMicrophoneStatusChanged");
            } catch (JSONException e) {
                OpenpathLogging.e("json exception", e);
            }
        }

        @Override
        public void onNotificationStatusChanged(OpenpathNotificationStatus notificationStatus) {
            try {
                WritableMap content = convertJsonToMap(OpenpathNotificationStatus.toJson(notificationStatus));
                sendData(content, "onNotificationStatusChanged");
            } catch (JSONException e) {
                OpenpathLogging.e("json exception", e);
            }
        }


        @Override
        public void onAudioDeviceStatusChanged(OpenpathAudioDeviceStatus openpathAudioDeviceStatus) {
            try {
                WritableMap content = convertJsonToMap(OpenpathAudioDeviceStatus.toJson(openpathAudioDeviceStatus));
                sendData(content, "onAudioDeviceStatusChanged");
            } catch (JSONException e) {
                OpenpathLogging.e("json exception", e);
            }
        }

        @Override
        public void onLocationStatusChanged(OpenpathLocationStatus locationStatus) {
            try {
                WritableMap content = convertJsonToMap(OpenpathLocationStatus.toJson(locationStatus));
                sendData(content, "onLocationStatusChanged");
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }

        @Override
        public void onBatteryOptimizationStatusChanged(boolean batteryOptimizationDisabled) {
            WritableMap content = Arguments.createMap();
            content.putBoolean("isBatteryOptimizationOn", !batteryOptimizationDisabled);
            sendData(content, "onBatteryOptimizationStatusChanged");
        }

        @Override
        public void onUserSettingsSet(OpenpathUserSettings user) {
            try {
                WritableMap jsonUser = Arguments.createMap();
                jsonUser.putBoolean("hasRemoteUnlock", user.hasRemoteUnlock);
                jsonUser.putBoolean("hasOverride", user.hasOverride);
                WritableArray cloudKeys = Arguments.createArray();
                for (CloudKey cloudKey : user.cloudKeys) {
                    cloudKeys.pushMap(convertJsonToMap(cloudKey.toJSON()));
                }
                jsonUser.putArray("cloudKeys", cloudKeys);
                WritableMap content = Arguments.createMap();
                content.putMap("userSettings", jsonUser);
                sendData(content, "onUserSettingsSet");
            } catch (JSONException e) {
                OpenpathLogging.e("json error", e);
            }
        }

        @Override
        public void onItemsSet(ArrayList<OpenpathItem> items, ArrayList<OpenpathOrderingItem> orderingItems, ArrayList<OpenpathCamera> cameras) {
            try {
                WritableMap jsonItems = Arguments.createMap();
                for (OpenpathItem item : items) {
                    WritableMap jsonItem = itemToJson(item);
                    jsonItems.putMap(item.type + "-" + item.id, jsonItem);
                }
                WritableArray jsonOrderingItems = Arguments.createArray();
                for (OpenpathOrderingItem orderingItem : orderingItems) {
                    WritableMap jsonOrderingItem = Arguments.createMap();
                    jsonOrderingItem.putInt("itemId", orderingItem.id);
                    jsonOrderingItem.putString("itemType", orderingItem.type);
                    if (orderingItem.subItems.size() > 0) {
                        WritableArray jsonSubItems = Arguments.createArray();
                        for (OpenpathOrderingItem subItem : orderingItem.subItems) {
                            WritableMap jsonSubItem = Arguments.createMap();
                            jsonSubItem.putInt("itemId", subItem.id);
                            jsonSubItem.putString("itemType", subItem.type);
                            jsonSubItems.pushMap(jsonSubItem);
                        }
                        jsonOrderingItem.putArray("subItems", jsonSubItems);
                    }
                    jsonOrderingItems.pushMap(jsonOrderingItem);
                }
                WritableArray jsonCameras = Arguments.createArray();
                for (OpenpathCamera camera : cameras) {
                    JSONObject jsonObject = OpenpathCamera.toJson(camera);
                    if (jsonObject != null) {
                        jsonCameras.pushMap(convertJsonToMap(jsonObject));
                    }
                }
                WritableMap content = Arguments.createMap();
                content.putMap("items", jsonItems);
                content.putArray("itemOrdering", jsonOrderingItems);
                content.putArray("cameras", jsonCameras);
                sendData(content,  "onItemsSet");
            } catch (JSONException e) {
                OpenpathLogging.e("json error", e);
            }
        }

        @Override
        public void onItemsUpdated(ArrayList<OpenpathItem> items) {
            try {
                WritableMap jsonItems = Arguments.createMap();
                for (OpenpathItem item : items) {
                    WritableMap jsonItem = itemToJson(item);
                    jsonItems.putMap(item.type + "-" + item.id, jsonItem);
                }
                WritableMap content = Arguments.createMap();
                content.putMap("items", jsonItems);
                sendData(content, "onItemsUpdated");
            } catch (JSONException e) {
                OpenpathLogging.e("json error", e);
            }
        }

        @Override
        public void onItemStatesUpdated(OpenpathItemState openpathItemState) {
            try {
                WritableMap content = Arguments.createMap();
                WritableMap jsonItemState = convertJsonToMap(openpathItemState.toJson());
                WritableMap jsonItemTypeItemId = Arguments.createMap();
                jsonItemTypeItemId.putMap(openpathItemState.itemType + "-" + openpathItemState.itemId, jsonItemState);
                content.putMap("itemStates", jsonItemTypeItemId);
                sendData(content, "onItemStatesUpdated");
            } catch (JSONException e) {
                OpenpathLogging.e("json error", e);
            }
        }

        @Override
        public void onLockdownPlansSet(ArrayList<OpenpathLockdownPlan> lockdownPlans) {
            try {
                WritableArray jsonLockdownPlans = Arguments.createArray();
                for (OpenpathLockdownPlan lockdownPlan : lockdownPlans) {
                    jsonLockdownPlans.pushMap(convertJsonToMap(lockdownPlan.toJSON()));
                }
                WritableMap content = Arguments.createMap();
                content.putArray("lockdownPlans", jsonLockdownPlans);
                sendData(content, "onLockdownPlansSet");
            } catch (JSONException e) {
                OpenpathLogging.e("json error", e);
            }
        }

        @Override
        public void onEvent(JSONObject message) {
            try {
                sendEvent(convertJsonToMap(message));
            } catch (JSONException e) {
                OpenpathLogging.e("json error", e);
            }
        }

        private void sendError(OpenpathResponse openpathResponse, String type) {
            if (openpathResponse.hasError()) {
                WritableMap message = Arguments.createMap();
                message.putString("type", type);
                WritableMap content = Arguments.createMap();
                WritableMap err = Arguments.fromBundle(openpathResponse.error.toBundle());
                content.putMap("err", err);
                message.putMap("content", content);
                sendEvent(message);
            }
        }

        private void sendData(WritableMap data, String type) {
            WritableMap message = Arguments.createMap();
            message.putString("type", type);
            WritableMap content = Arguments.createMap();
            content.putMap("data", data);
            message.putMap("content", content);
            OpenpathLogging.d(message.toString());
            sendEvent(message);
        }

        private void sendEvent(WritableMap message) {
            ReactContext context = getReactApplicationContext();
            if (context != null && context.hasActiveCatalystInstance()) {
                context.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("OpenpathEvent", message);
            }
        }
    };
}
