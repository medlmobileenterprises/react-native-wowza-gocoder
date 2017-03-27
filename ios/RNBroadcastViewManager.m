//
//  RNBroadcastViewManager.m
//  WowzaMedlReactNativeModule
//
//  Created by Hugo Nagano on 11/4/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "RNBroadcastViewManager.h"
#import "RNBroadcastView.h"

@implementation RNBroadcastViewManager
RCT_EXPORT_MODULE();

@synthesize bridge = _bridge;

- (UIView *) view {
    return [[RNBroadcastView alloc] initWithEventDispatcher:self.bridge.eventDispatcher];
}
RCT_EXPORT_VIEW_PROPERTY(hostAddress, NSString);
RCT_EXPORT_VIEW_PROPERTY(applicationName, NSString);
RCT_EXPORT_VIEW_PROPERTY(broadcastName, NSString);
RCT_EXPORT_VIEW_PROPERTY(sdkLicenseKey, NSString);
RCT_EXPORT_VIEW_PROPERTY(port, NSNumber);
RCT_EXPORT_VIEW_PROPERTY(backgroundMode, BOOL);
RCT_EXPORT_VIEW_PROPERTY(sizePreset, NSInteger);
RCT_EXPORT_VIEW_PROPERTY(username, NSString);
RCT_EXPORT_VIEW_PROPERTY(password, NSString);
RCT_EXPORT_VIEW_PROPERTY(muted, BOOL);
RCT_EXPORT_VIEW_PROPERTY(broadcasting, BOOL);
RCT_EXPORT_VIEW_PROPERTY(flashOn, BOOL);
RCT_EXPORT_VIEW_PROPERTY(frontCamera, BOOL);
RCT_EXPORT_VIEW_PROPERTY(onBroadcastStart, RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onBroadcastFail, RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onBroadcastStatusChange, RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onBroadcastEventReceive, RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onBroadcastErrorReceive, RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onBroadcastVideoEncoded, RCTDirectEventBlock);
RCT_EXPORT_VIEW_PROPERTY(onBroadcastStop, RCTDirectEventBlock);
- (dispatch_queue_t) methodQueue {
    return dispatch_get_main_queue();
}

- (NSArray *) customDirectEventTypes {
    return @[@"onBroadcastStart",
             @"onBroadcastFail",
             @"onBroadcastStatusChange",
             @"onBroadcastEventReceive",
             @"onBroadcastErrorReceive",
             @"onBroadcastVideoEncoded",
             @"onBroadcastStop"];
}

- (NSDictionary *) constantsToExport {
    return @{
             @"ScaleAspectFit": @(UIViewContentModeScaleAspectFit),
             @"ScaleAspectFill": @(UIViewContentModeScaleAspectFill),
             @"ScaleToFill": @(UIViewContentModeScaleToFill)
             };
}
@end
