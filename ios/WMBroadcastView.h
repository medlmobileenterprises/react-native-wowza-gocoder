//
//  WMBroadcastView.h
//  WowzaMedl
//
//  Created by Hugo Nagano on 10/27/16.
//  Copyright © 2016 Hugo Nagano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMBroadcastViewDelegate.h"

@class WowzaConfig;

@interface WMBroadcastView : NSObject
typedef void (^completionBlock)(NSError *error);

@property (nonatomic, weak) id<WMBroadcastViewDelegate> delegate;

-(void)initializeBroadcastView:(UIView *)broadcastView;
-(id)initWithLicenseKey:(NSString *)licenseKey andStreamConfig:(WowzaConfig *)config ;

-(void)updateBroadcastViewPosition:(CGRect)rect;
-(void)startBroadcasting;
-(void)stopBroadcasting;
-(void)muteBroacast:(BOOL)muted;
-(void)setFlashState:(BOOL)state;
-(NSUInteger)invertCamera;
-(void)closeBroadcast;
-(void)setStreamName:(NSString*)name;

@end
