//
//  HighLightButton.m
//  yungui
//
//  Created by zhaoqihao on 10/10/14.
//  Copyright (c) 2014 com.zhaoqihao. All rights reserved.
//

#import "HighLightButton.h"

@implementation HighLightButton

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureButton];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame normalColor:(UIColor *)normalColor highLightColor:(UIColor *)highLightColor{
    self.normalColor=normalColor;
    self.highLightColor=highLightColor;
    [self setBackgroundColor:self.normalColor];
    
    return [self initWithFrame:frame];
}

-(void)awakeFromNib{
    [self configureButton];
}

-(void)configureButton{
    [self addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(touchCancel) forControlEvents:UIControlEventTouchCancel];
    [self addTarget:self action:@selector(touchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
}

-(void)touchDown{
    if(self.highLightColor)
        self.backgroundColor=self.highLightColor;
}

-(void)touchUpInside{
    if(self.normalColor)
        self.backgroundColor=self.normalColor;
    
    if(self.info)
        [self triggerForwardMessage:self.info,FM_END_FLAG];
    else
        [self triggerForwardMessage:FM_END_FLAG];
}

-(void)touchCancel{
    if(self.normalColor)
        self.backgroundColor=self.normalColor;
}

-(void)touchUpOutside{
    if(self.normalColor)
        self.backgroundColor=self.normalColor;
}

@end
