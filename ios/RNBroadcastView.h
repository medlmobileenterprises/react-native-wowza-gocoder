//
//  RNBroadcastView.h
//  WowzaMedlReactNativeModule
//
//  Created by Hugo Nagano on 11/4/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTView.h>

@class RCTEventDispatcher;
@interface RNBroadcastView : UIView
- (instancetype)initWithEventDispatcher:(RCTEventDispatcher *)eventDispatcher;
@end
