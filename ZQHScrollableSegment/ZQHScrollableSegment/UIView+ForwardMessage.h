//
//  UIView+ForwardMessage.h
//  lingmiapp
//
//  Created by lmwl123 on 12/21/14.
//  Copyright (c) 2014 LingMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define FM_END_FLAG @"triggerForwardMessageListEndFlag"

@interface UIView (ForwardMessage)

@property (weak,nonatomic) id viewController;
@property (strong,nonatomic) NSString *selectorName;

-(void)triggerForwardMessage:(id)obj1,...;

@end
