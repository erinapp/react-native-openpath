//
//  TitaniumNativeModuleBridge.m
//  Titanium
//
//  Created by Jacqueline Mak on 3/8/17.
//  Copyright © 2017 OpenPath Security, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(ReactNativeOpenpath, RCTEventEmitter)

// Framework documented public methods
RCT_EXTERN_METHOD(provision:(NSString*)setupMobileToken)
RCT_EXTERN_METHOD(unprovision:(nullable NSString *)userOpal)
RCT_EXTERN_METHOD(switchUser:(NSString*)userOpal)
RCT_EXTERN_METHOD(syncUser)
RCT_EXTERN_METHOD(requestAuthorization:(NSString*)authType)

RCT_EXTERN_METHOD(unlock:(NSString*)itemType itemId:(NSInteger*)itemId requestId:(NSInteger*)requestId timeout:(NSInteger*)timeout)
RCT_EXTERN_METHOD(refreshItemState:(NSString*)itemType itemId:(NSInteger*)itemId)
RCT_EXTERN_METHOD(softRefresh)
RCT_EXTERN_METHOD(refreshUserSettings)

// Getters
RCT_EXTERN_METHOD(getSdkVersion:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(getAuthorizationStatuses:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(getUserApiToken:(NSString*)userOpal resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(getReadersInRange:(NSInteger*)rssiThreshold resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(sendFeedback:(NSString*)subject message:(NSString*)message messageJson:(NSString*)messageJson)
RCT_EXTERN_METHOD(getErrors:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)

// Notifications
RCT_EXTERN_METHOD(enableErrorNotificationsForItem:(NSString*)itemType itemId:(NSInteger*)itemId)
RCT_EXTERN_METHOD(disableErrorNotificationsForItem:(NSString*)itemType itemId:(NSInteger*)itemId)

// Nearby readers
RCT_EXTERN_METHOD(getReadersInRange:(NSInteger*)rssiThreshold resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup
{
  return YES;
}

@end
