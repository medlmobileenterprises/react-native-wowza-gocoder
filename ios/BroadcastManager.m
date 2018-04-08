//
//  BroadcastManager.m
//  Friendable
//
//  Created by Hugo Nagano on 11/2/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "BroadcastManager.h"
#import "WMBroadcastView.h"
#import <React/RCTConvert.h>
#import "WowzaGoCoderSDK.h"

@implementation RCTConvert(UIView)

+(UIView *)BroadCastView:(id)json{
    NSDictionary<NSString *, id> *details = [self NSDictionary:json];
    return [details objectForKey:@"view"];
}

@end
@interface BroadcastManager()


@property (nonatomic, strong) NSString *broadcastName;
@end
@implementation BroadcastManager
static BroadcastManager *sharedMyManager = nil;
+ (id)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}

+(WMBroadcastView *)initializeBroadcasterWithSdkLicence:(NSString *)sdkLicence
                                         andHostAddress:(NSString *)hostAddress
                                             portNumber:(NSInteger)port
                                        applicationName:(NSString *)applicationName
                                          broadcastName:(NSString *)broadcastName
                                               username:(NSString *)username
                                               password:(NSString *)password
                                         backgroundMode:(BOOL)backgroundMode
                                             sizePreset:(NSInteger)sizePreset
                                       videoOrientation:(NSString *)videoOrientation
                                            frontCamera:(BOOL)frontCamera
                                       andBroadcastView:(UIView *)view
{
    
    
    WowzaConfig *config = [[WowzaConfig alloc] initWithPreset:sizePreset];
    config.hostAddress = hostAddress;
    config.portNumber = 1935;
    if(port){
        config.portNumber = port;
    }
    config.applicationName = applicationName;
    config.streamName = broadcastName;
    config.broadcastScaleMode = WOWZBroadcastScaleModeAspectFill;
    config.backgroundBroadcastEnabled = backgroundMode;
    config.username = username;
    config.password = password;
    config.broadcastVideoOrientation = [BroadcastManager getBroadcastOrientation:videoOrientation];
    if (videoOrientation) {
        config.capturedVideoRotates = NO;
    }
    
    NSLog(@"user %@", username);
    NSLog(@"Password %@", password);
    
    WMBroadcastView *broadcast = [[WMBroadcastView alloc] initWithLicenseKey:sdkLicence andStreamConfig:config];
    
    [broadcast initializeBroadcastView:view];
    
    if (frontCamera) {
        [self invertCamera:broadcast];
    }
    
    return broadcast;
}
+(void)startBroadcast:(WMBroadcastView *) broadcast{
    [broadcast startBroadcasting];
}
+(void)stopBroadcast:(WMBroadcastView *) broadcast{
    [broadcast stopBroadcasting];
}
+(void)invertCamera:(WMBroadcastView *) broadcast{
    [broadcast invertCamera];
}

+(void)switchFlash:(BOOL)on andBroadcastView:(WMBroadcastView *) broadcast{
    [broadcast setFlashState:on];
}
+(void)turnMic:(BOOL)on andBroadcastView:(WMBroadcastView *) broadcast{
    [broadcast muteBroacast:on];
}
+(void)releaseBroadcast:(WMBroadcastView *) broadcast{
    [broadcast closeBroadcast];
}
+(void)changeFrame:(CGRect)frame andBroadcastView:(WMBroadcastView *) broadcast{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [broadcast updateBroadcastViewPosition:frame];
    });
}
+(void)changeStreamName:(NSString *)name andBroadcastView:(WMBroadcastView *)broadcast {
    [broadcast setStreamName:name];
}

+(WOWZBroadcastOrientation)getBroadcastOrientation:(NSString *)orientationString {
    if ([orientationString isEqualToString:@"landscape"]) {
        return WOWZBroadcastOrientationAlwaysLandscape;
    } else if ([orientationString isEqualToString:@"portrait"]) {
        return WOWZBroadcastOrientationAlwaysPortrait;
    }
    
    return WOWZBroadcastOrientationSameAsDevice;
}

@end
