//
//  HighLightButton.h
//  yungui
//
//  Created by zhaoqihao on 10/10/14.
//  Copyright (c) 2014 com.zhaoqihao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+ForwardMessage.h"

@interface HighLightButton : UIButton

@property (nonatomic,strong) UIColor *normalColor;
@property (nonatomic,strong) UIColor *highLightColor;

@property (strong,nonatomic) id info;

-(id)initWithFrame:(CGRect)frame normalColor:(UIColor *)normalColor highLightColor:(UIColor *)highLightColor;

@end
