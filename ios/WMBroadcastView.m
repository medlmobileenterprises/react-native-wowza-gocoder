//
//  WMBroadcastView.m
//  WowzaMedl
//
//  Created by Hugo Nagano on 10/27/16.
//  Copyright © 2016 Hugo Nagano. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "WMBroadcastView.h"
#import "WowzaGoCoderSDK.h"


NSString * const BlackAndWhiteKey = @"BlackAndWhiteKey";
@interface WMBroadcastView()<WZStatusCallback, WZVideoSink, WZAudioSink, WZVideoEncoderSink, WZAudioEncoderSink>


@property (nonatomic, strong) WowzaGoCoder *goCoder;
@property (nonatomic, strong) WZCameraPreview *goCoderCameraPreview;
@property (nonatomic, strong) UIView *broadcastView;
@property (nonatomic, strong) WowzaConfig *wozwaConfig;
@property (nonatomic, strong) NSMutableArray    *receivedGoCoderEventCodes;
@property (nonatomic, assign) BOOL              blackAndWhiteVideoEffect;
@property (nonatomic, assign) CMTime            broadcastStartTime;
@property (nonatomic, assign) NSInteger         currentSeconds;
#pragma mark - WZData injection
@property (nonatomic, assign) long long         broadcastFrameCount;
@end

@implementation WMBroadcastView
#pragma mark - Public Functions
-(id)initWithLicenseKey:(NSString *)licenseKey andStreamConfig:(WowzaConfig *)config {
    self = [super init];
    if(!self){
        return nil;
    }
    
    [self registerLicense:licenseKey];
    self.wozwaConfig = config;
    
    return self;
}

-(void)initializeBroadcastView:(UIView *)broadcastView{
    self.goCoder = [WowzaGoCoder sharedInstance];
    
    // Specify the view in which to display the camera preview
    if (self.goCoder == nil) {
        return;
    }
    // Request camera and microphone permissions
    [WowzaGoCoder requestPermissionForType:WowzaGoCoderPermissionTypeCamera response:^(WowzaGoCoderCapturePermission permission) {
        NSLog(@"Camera permission is: %@", permission == WowzaGoCoderCapturePermissionAuthorized ? @"authorized" : @"denied");
    }];
    
    [WowzaGoCoder requestPermissionForType:WowzaGoCoderPermissionTypeMicrophone response:^(WowzaGoCoderCapturePermission permission) {
        NSLog(@"Microphone permission is: %@", permission == WowzaGoCoderCapturePermissionAuthorized ? @"authorized" : @"denied");
    }];
    [self initGoCoder];
    [self.goCoder registerVideoSink:self];
    [self.goCoder registerAudioSink:self];
    [self.goCoder registerVideoEncoderSink:self];
    [self.goCoder registerAudioEncoderSink:self];
    self.currentSeconds = 0;
    self.goCoder.config = self.wozwaConfig;
    [self.goCoder setCameraView:broadcastView];
    
    // Start the camera preview
    self.goCoderCameraPreview = self.goCoder.cameraPreview;
    self.goCoderCameraPreview.previewGravity = WZCameraPreviewGravityResizeAspectFill;
    [self.goCoderCameraPreview startPreview];
    
}
-(void)closeBroadcast{
    [self unRegisterDelegate];
    _goCoder = nil;
    _goCoderCameraPreview = nil;
}
-(void)startBroadcasting{
    NSError *configError = [self.goCoder.config validateForBroadcast];
    if (configError != nil) {
        //DELEGATE
        [self.delegate didFailToStartBroadcast:configError];
        return;
    }
    
    [self.receivedGoCoderEventCodes removeAllObjects];
    [self.goCoder startStreaming:self];
    
    
    [self.delegate didStartBroacast];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    

}
-(void)stopBroadcasting{
    if (self.goCoder.status.state == WZStateRunning) {
        [self.goCoder endStreaming:self];
        [UIApplication sharedApplication].idleTimerDisabled = NO;
    }
}
-(void)updateBroadcastViewPosition:(CGRect)rect{
    self.goCoder.cameraPreview.previewLayer.frame   = rect;
}
-(void)muteBroacast:(BOOL)muted{
    self.goCoder.audioMuted = muted;
}
-(void)setFlashState:(BOOL)state{
    self.goCoder.cameraPreview.camera.torchOn = state;
}
-(void)setStreamName:(NSString*)name{
    self.goCoder.config.streamName = name;
}
-(NSUInteger)invertCamera{
    WZCamera *otherCamera = [self.goCoderCameraPreview otherCamera];
    if (![otherCamera supportsWidth:self.wozwaConfig.videoWidth]) {
        [self.wozwaConfig loadPreset:otherCamera.supportedPresetConfigs.lastObject.toPreset];
        self.goCoder.config = self.wozwaConfig;
    }
    [self.goCoderCameraPreview switchCamera];
    //0 Back - 1 Front
    return self.goCoderCameraPreview.camera.direction;
}
#pragma mark - Private Functions
-(void)initGoCoder{
    self.receivedGoCoderEventCodes = [NSMutableArray new];
    self.blackAndWhiteVideoEffect = [[NSUserDefaults standardUserDefaults] boolForKey:BlackAndWhiteKey];
    self.broadcastStartTime = kCMTimeInvalid;
    [WowzaGoCoder setLogLevel:WowzaGoCoderLogLevelVerbose];
}
-(void)registerLicense:(NSString *)licenseKey{
    NSError *goCoderLicensingError = [WowzaGoCoder registerLicenseKey:licenseKey];
    if(goCoderLicensingError){
        [NSException raise:@"Invalid License" format:@"There was a problem with your license key: %@", goCoderLicensingError.localizedDescription];
    }
}
-(void)unRegisterDelegate{
    [self.goCoder unregisterAudioSink:self];
    [self.goCoder unregisterVideoSink:self];
    [self.goCoder unregisterAudioEncoderSink:self];
    [self.goCoder unregisterVideoEncoderSink:self];
}
#pragma mark - WZStatusCallback Protocol Instance Methods
- (void) onWZStatus:(WZStatus *) goCoderStatus {
    NSLog(@"status %@", goCoderStatus);
    // A successful status transition has been reported by the GoCoder SDK
    [self.delegate broadcastStatusDidChange:goCoderStatus.state];
    
}

- (void) onWZEvent:(WZStatus *) goCoderStatus {
    // If an event is reported by the GoCoder SDK, display an alert dialog describing the event,
    // but only if we haven't already shown an alert for this event
    NSLog(@"event status %@", goCoderStatus);
    NSLog(@" status error %@", goCoderStatus.error);
    dispatch_async(dispatch_get_main_queue(), ^{
        __block BOOL haveSeenAlertForEvent = NO;
        [self.receivedGoCoderEventCodes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([((NSNumber *)obj) isEqualToNumber:[NSNumber numberWithInteger:goCoderStatus.error.code]]) {
                haveSeenAlertForEvent = YES;
                *stop = YES;
            }
        }];
        if (!haveSeenAlertForEvent) {

            [self.receivedGoCoderEventCodes addObject:[NSNumber numberWithInteger:goCoderStatus.error.code]];
            [self.delegate broadcastDidReceiveEvent:goCoderStatus.event andError:goCoderStatus.error];
            
        }
        

    });
}

- (void) onWZError:(WZStatus *) goCoderStatus {
    // If an error is reported by the GoCoder SDK, display an alert dialog containing the error details
    
    [self.delegate broadcastDidReceiveError:goCoderStatus.error];
}

#pragma mark - WZVideoSink

#warning Don't implement this protocol unless your application makes use of it
- (void) videoFrameWasCaptured:(nonnull CVImageBufferRef)imageBuffer framePresentationTime:(CMTime)framePresentationTime frameDuration:(CMTime)frameDuration {
    if (self.goCoder.isStreaming) {
        
        if (self.blackAndWhiteVideoEffect) {
            // convert frame to b/w using CoreImage tonal filter
            CIImage *frameImage = [[CIImage alloc] initWithCVImageBuffer:imageBuffer];
            CIFilter *grayFilter = [CIFilter filterWithName:@"CIPhotoEffectTonal"];
            [grayFilter setValue:frameImage forKeyPath:@"inputImage"];
            frameImage = [grayFilter outputImage];
            
            CIContext * context = [CIContext contextWithOptions:nil];
            [context render:frameImage toCVPixelBuffer:imageBuffer];
        }
        
    }
}

- (void) videoCaptureInterruptionStarted {
    if (!self.wozwaConfig.backgroundBroadcastEnabled) {
        [self.goCoder endStreaming:self];
    }
}

- (void) videoCaptureUsingQueue:(nullable dispatch_queue_t)queue {
//    self.video_capture_queue = queue;
}

#pragma mark - WZAudioSink

#warning Don't implement this protocol unless your application makes use of it
- (void) audioLevelDidChange:(float)level {
    
}

#warning Don't implement this protocol unless your application makes use of it
- (void) audioPCMFrameWasCaptured:(nonnull const AudioStreamBasicDescription *)pcmASBD bufferList:(nonnull const AudioBufferList *)bufferList time:(CMTime)time sampleRate:(Float64)sampleRate {
   
}


#pragma mark - WZAudioEncoderSink

#warning Don't implement this protocol unless your application makes use of it
- (void) audioSampleWasEncoded:(nullable CMSampleBufferRef)data {
    
}


#pragma mark - WZVideoEncoderSink

#warning Don't implement this protocol unless your application makes use of it
- (void) videoFrameWasEncoded:(nonnull CMSampleBufferRef)data {
    
    // update the broadcast time label
    if (CMTimeCompare(self.broadcastStartTime, kCMTimeInvalid) == 0) {
        self.broadcastStartTime = CMSampleBufferGetPresentationTimeStamp(data);
    }
    else {
        CMTime diff = CMTimeSubtract(CMSampleBufferGetPresentationTimeStamp(data), self.broadcastStartTime);
        Float64 seconds = CMTimeGetSeconds(diff);
        NSInteger timepassed = (NSInteger)seconds;
        NSInteger second = 0;
        if(timepassed - self.currentSeconds >= 1){
            [self.delegate brodcastVideoFrameWasEncoded:timepassed];
            self.currentSeconds = timepassed;
        }
       
    }
}

@end
