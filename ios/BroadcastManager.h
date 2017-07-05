//
//  BroadcastManager.h
//  Friendable
//
//  Created by Hugo Nagano on 11/2/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class WMBroadcastView;
static NSString *didStartBroadcast                = @"onBroadcastStart";
static NSString *didFailToBroadcast               = @"onBroadcastFail";
static NSString *broadcastStatusChange            = @"onBroadcastStatusChange";
static NSString *broadcastDidReceiveEvent         = @"onBroadcastEventReceive";
static NSString *broadcastDidReceiveError         = @"onBroadcastErrorReceive";
static NSString *broadcastVideoFrameWasEncoded    = @"onBroadcastVideoEncoded";
static NSString *didStopBroadcast                 = @"onBroadcastStop";
@interface BroadcastManager : NSObject

@property (nonatomic, assign) BOOL isViewSet;

+(WMBroadcastView *)initializeBroadcasterWithSdkLicence:(NSString *)sdkLicence
                                         andHostAddress:(NSString *)hostAddress
                                             portNumber:(NSInteger)port
                                        applicationName:(NSString *)applicationName
                                          broadcastName:(NSString *)broadcastName
                                               username:(NSString *)username
                                               password:(NSString *)password
                                         backgroundMode:(BOOL)backgroundMode
                                             sizePreset:(NSInteger)sizePreset
                                       andBroadcastView:(UIView *)view;
+(void)startBroadcast:(WMBroadcastView *) broadcast;
+(void)stopBroadcast:(WMBroadcastView *) broadcast;
+(void)invertCamera:(WMBroadcastView *) broadcast;
+(void)switchFlash:(BOOL)on andBroadcastView:(WMBroadcastView *) broadcast;
+(void)turnMic:(BOOL)on andBroadcastView:(WMBroadcastView *) broadcast;

+(void)releaseBroadcast:(WMBroadcastView *) broadcast;
+(void)changeFrame:(CGRect)frame andBroadcastView:(WMBroadcastView *) broadcast;
+(void)changeStreamName:(NSString *)name andBroadcastView:(WMBroadcastView *)broadcast;
@end
