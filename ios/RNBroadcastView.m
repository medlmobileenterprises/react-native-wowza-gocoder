//
//  RNBroadcastView.m
//  WowzaMedlReactNativeModule
//
//  Created by Hugo Nagano on 11/4/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "RNBroadcastView.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTEventDispatcher.h>
#import <React/UIView+React.h>
#import "WMBroadcastView.h"
#import "BroadcastManager.h"
#import "WowzaGoCoderSDK.h"

//static NSDictionary *onLoadParamsForSource()
//{
//  NSDictionary *dict = @{
//                         @"width": @(source.size.width),
//                         @"height": @(source.size.height),
//
//                         };
//  return @{ @"source": dict };
//}
@interface RNBroadcastView()<WMBroadcastViewDelegate>
@property (nonatomic, copy) RCTDirectEventBlock onBroadcastStart;
@property (nonatomic, copy) RCTDirectEventBlock onBroadcastFail;
@property (nonatomic, copy) RCTDirectEventBlock onBroadcastStatusChange;
@property (nonatomic, copy) RCTDirectEventBlock onBroadcastEventReceive;
@property (nonatomic, copy) RCTDirectEventBlock onBroadcastErrorReceive;
@property (nonatomic, copy) RCTDirectEventBlock onBroadcastVideoEncoded;
@property (nonatomic, copy) RCTDirectEventBlock onBroadcastStop;

@property (nonatomic, strong) NSString *sdkLicenseKey;
@property (nonatomic, strong) NSString *hostAddress;
@property (nonatomic, assign) NSNumber *port;
@property (nonatomic, strong) NSString *applicationName;
@property (nonatomic, strong) NSString *broadcastName;
@property (nonatomic, assign) BOOL backgroundMode;
@property (nonatomic, assign) NSInteger sizePreset;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, assign) BOOL broadcasting;
@property (nonatomic, assign) BOOL flashOn;
@property (nonatomic, assign) BOOL frontCamera;
@property (nonatomic, assign) BOOL muted;
@property (nonatomic, strong) WMBroadcastView *broadcast;

@end
@implementation RNBroadcastView {
    RCTEventDispatcher *_eventDispatcher;
}

- (instancetype)init {
    NSLog(@"init");
    self = [super init];
    if ( self ) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if ( self ) {
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( self ) {
        
    }
    return self;
}
- (instancetype)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher{
    if ((self = [super init])) {
        _eventDispatcher = eventDispatcher;
        
    }
    
    return self;
}
- (void)layoutMarginsDidChange{
    [super layoutMarginsDidChange];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    if(!self.broadcast){
        _broadcast = [BroadcastManager initializeBroadcasterWithSdkLicence:self.sdkLicenseKey
                                                            andHostAddress:self.hostAddress
                                                                portNumber:[self.port integerValue]
                                                           applicationName:self.applicationName
                                                             broadcastName:self.broadcastName
                                                                  username:self.username
                                                                  password:self.password
                                                            backgroundMode:self.backgroundMode
                                                                sizePreset:self.sizePreset
                                                          andBroadcastView:self];
        self.broadcast.delegate = self;
    }
    
}
-(void)didUpdateReactSubviews{
    [super didUpdateReactSubviews];
    
}
-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    
}

- (void)removeFromSuperview {
    [BroadcastManager releaseBroadcast:self.broadcast];
    _eventDispatcher = nil;
    [super removeFromSuperview];
}

#pragma mark - Setters Props
-(void)setBroadcasting:(BOOL)broadcasting{
    if(self.broadcast){
        if(broadcasting){
            [BroadcastManager startBroadcast:self.broadcast];
        }
        else{
            [BroadcastManager stopBroadcast:self.broadcast];
        }
    }
    _broadcasting = broadcasting;
}
-(void)setMuted:(BOOL)muted{
    [BroadcastManager turnMic:muted andBroadcastView:self.broadcast];
    _muted = muted;
    
}
-(void)setFlashOn:(BOOL)flashOn{
    [BroadcastManager switchFlash:flashOn andBroadcastView:self.broadcast];
    _flashOn = flashOn;
}
-(void)setFrontCamera:(BOOL)frontCamera{
    [BroadcastManager invertCamera:self.broadcast];
    _frontCamera = frontCamera;
}
-(void)setBroadcastName:(NSString *)broadcastName{
    [BroadcastManager changeStreamName:broadcastName andBroadcastView:self.broadcast];
    _broadcastName = broadcastName;
}
#pragma mark - WMBroadcastViewDelegate Methods

-(void)didStartBroacast{
    self.onBroadcastStart(@{@"event":@{@"host":self.hostAddress, @"broadcastName":self.broadcastName}});
}
-(void)didFailToStartBroadcast:(NSError *)error{
    //show error
    self.onBroadcastFail(@{@"error":error.localizedDescription});
}
-(void)broadcastStatusDidChange:(WZState)state{
    NSString *stateString;
    switch (state) {
        case WZStateIdle:
            stateString = @"idle";
            self.onBroadcastStop(@{@"event":@{@"host":self.hostAddress, @"broadcastName":self.broadcastName, @"status": @"stopped"}});
            break;
        case WZStateRunning:
            stateString = @"running";
            break;
        case WZStateStarting:
            stateString = @"starting";
            break;
        case WZStateStopping:
            stateString = @"stopping";
            break;
        default:
            break;
    }
    
}
-(void)broadcastDidReceiveEvent:(WZEvent)event andError:(NSError *)error{
    if(error){
        self.onBroadcastErrorReceive(@{@"error":error.localizedDescription});
    }
    else{
        self.onBroadcastEventReceive(@{@"event": [NSNumber numberWithInteger:event]});
        
    }
    
}
-(void)broadcastDidReceiveError:(NSError *) error{
    if(error){
        self.onBroadcastErrorReceive(@{@"error":error.localizedDescription});
    }
}
-(void)brodcastVideoFrameWasEncoded:(NSInteger *)durationInSeconds{
    self.onBroadcastVideoEncoded(@{@"seconds":[NSNumber numberWithInteger:durationInSeconds]});
}

@end
