//
//  ZQHScrollableSegment.h
//  ZQHScrollableSegment
//
//  Created by lmwl123 on 12/23/14.
//  Copyright (c) 2014 zhaoqihao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+ForwardMessage.h"

/*
 If you click an item, this object can forward the index with NSNumber to your controller,
 you can write your custom code in your controller with the NSNumber index.
 */

@interface ZQHScrollableSegment : UIView

/*
 The items contains titles, you must put string value in it.
 */
@property (strong,nonatomic) NSArray *items;

/*
 The separator line's width, default is 0.5;
 If you assign it 0, it will be the default value.
 */
@property (assign,nonatomic) CGFloat separatorLineWidth;

/*
 The indicator line's height, default is 4;
 If you assign it 0, it will be the default value.
 */
@property (assign,nonatomic) CGFloat indicatorLineHeight;

/*
 The title color in normal state, default is gray.
 */
@property (strong,nonatomic) UIColor *titleNormalColor;

/*
 The title color in chosen state, default is black.
 */
@property (strong,nonatomic) UIColor *titleHighLightColor;

/*
 The indicator line color, default is green.
 */
@property (strong,nonatomic) UIColor *indicatorColor;

/*
 The separator line color, default is [UIColor colorWithWhite:0.7 alpha:1].
 */
@property (strong,nonatomic) UIColor *separatorColor;

/*
 The high light color when each item has been selected, default is [UIColor colorWithWhite:0.95 alpha:1].
 */
@property (strong,nonatomic) UIColor *highLightColor;


@end
