//
//  ZQHScrollableSegment.m
//  ZQHScrollableSegment
//
//  Created by lmwl123 on 12/23/14.
//  Copyright (c) 2014 zhaoqihao. All rights reserved.
//

#import "ZQHScrollableSegment.h"
#import "HighLightButton.h"
#import <objc/runtime.h>

@interface ZQHScrollableSegment(){
    __weak UIScrollView *sv;
    __weak CALayer *indicatorLine;
    CGFloat segmentWidth;
    
    NSMutableArray *buttons;
}

@property (assign,nonatomic) NSUInteger currentIndex;

@end

NSString * const ChangeBackgroundColorNotif=@"ChangeBackgroundColorNotification";
NSString * const ColorKey=@"ColorKey";

@interface NoteLayer : CALayer

@end

#define DEFAULT_INDICATOR_LINE_HEIGHT 4
#define DEFAULT_SEPARATOR_LINE_WIDTH 0.5

NSString * const DeltaIncrementKey=@"ItemDeltaIncrementKey";
NSString * const DeltaDecrementKey=@"ItemDeltaDecrementKey";

@implementation ZQHScrollableSegment

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, [UIScreen mainScreen].bounds.size.width,35)];
    if(self){
        [self prepare];
    }
    
    return self;
}

-(void)awakeFromNib{
    [self prepare];
}

-(void)prepare{
    if(_separatorLineWidth==0) _separatorLineWidth=DEFAULT_SEPARATOR_LINE_WIDTH;
    if(!_separatorColor) _separatorColor=[UIColor colorWithWhite:0.7 alpha:1];
    
    for(id obj in self.subviews)
        if([obj isKindOfClass:[UIScrollView class]]) [obj removeFromSuperview];
    
    for(id layer in self.layer.sublayers)
        if([layer isKindOfClass:[CALayer class]]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [layer removeFromSuperlayer];
            });
        }
    
    NoteLayer *bottomSeparatorLine=[[NoteLayer alloc]init];
    [bottomSeparatorLine setFrame:CGRectMake(0, self.bounds.size.height-_separatorLineWidth, self.bounds.size.width, _separatorLineWidth)];
    [bottomSeparatorLine setBackgroundColor:_separatorColor.CGColor];
    [self.layer addSublayer:bottomSeparatorLine];
    
    UIScrollView *s=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    sv=s;
    
    sv.backgroundColor=[UIColor clearColor];
    [self addSubview:sv];
    
    [sv setShowsHorizontalScrollIndicator:NO];
    [sv setShowsVerticalScrollIndicator:NO];
    [sv setAlwaysBounceHorizontal:YES];
    [sv setAlwaysBounceVertical:NO];
}

-(void)updateIndicatorLocation{
    [indicatorLine setPosition:CGPointMake((self.currentIndex+0.5)*segmentWidth, indicatorLine.position.y)];
    [self setButtonsColor];
}

-(void)updateItemLocationWithOldIndex:(NSInteger)oldIndex{
    if(self.currentIndex>oldIndex){
        NSInteger index=self.currentIndex==self.items.count-1?self.currentIndex:self.currentIndex+1;
        HighLightButton *b=[buttons objectAtIndex:index];
        CGFloat offsetX=((NSNumber *)objc_getAssociatedObject(b, (__bridge const void *)DeltaIncrementKey)).floatValue;
        if(offsetX>sv.contentOffset.x)
            [sv setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }else{
        NSInteger index=self.currentIndex==0?self.currentIndex:self.currentIndex-1;
        HighLightButton *b=[buttons objectAtIndex:index];
        CGFloat offsetX=((NSNumber *)objc_getAssociatedObject(b, (__bridge const void *)DeltaDecrementKey)).floatValue;
        if(offsetX<sv.contentOffset.x)
            [sv setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
}

-(void)choiceItem:(HighLightButton *)sender{
    NSInteger index=[sender tag];
    if(index<0 || index>self.items.count-1 || index==self.currentIndex) return;
    
    NSInteger oldIndex=self.currentIndex;
    self.currentIndex=index;
    [self updateItemLocationWithOldIndex:oldIndex];
    [self updateIndicatorLocation];
    [self triggerForwardMessage:[NSNumber numberWithInteger:index],FM_END_FLAG];
}

-(void)setButtonsColor{
    HighLightButton *highLightButton=[buttons objectAtIndex:self.currentIndex];
    for(HighLightButton *button in buttons){
        if(button==highLightButton) [button setTitleColor:_titleHighLightColor forState:UIControlStateNormal];
        else [button setTitleColor:_titleNormalColor forState:UIControlStateNormal];
    }
}

#pragma mark - Setters

-(void)setItems:(NSArray *)items{
    if(!items || items.count==0) return;
    _items=[items copy];
    
    if(!buttons)
        buttons=[[NSMutableArray alloc]init];
    [buttons removeAllObjects];
    
    for(id obj in sv.subviews)
        if([obj isKindOfClass:[HighLightButton class]]) [obj removeFromSuperview];
    
    for(id layer in sv.layer.sublayers)
        if([layer isKindOfClass:[CALayer class]]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [layer removeFromSuperlayer];
            });
        }
    
    segmentWidth=100;
    if(items.count*segmentWidth<self.bounds.size.width)
        segmentWidth=segmentWidth=self.bounds.size.width/items.count;
    
    if(!_titleNormalColor) _titleNormalColor=[UIColor grayColor];
    if(!_titleHighLightColor) _titleHighLightColor=[UIColor blackColor];
    if(!_highLightColor) _highLightColor=[UIColor colorWithWhite:0.95 alpha:1];
    
    CGFloat coordinateX=0;
    CGFloat deltaTemp=0;
    
    for(int i=0;i<items.count;i++){
        HighLightButton *b=[[HighLightButton alloc]initWithFrame:CGRectMake(coordinateX+_separatorLineWidth/2, 0, segmentWidth-_separatorLineWidth, self.bounds.size.height-_separatorLineWidth) normalColor:[UIColor clearColor] highLightColor:_highLightColor];
        [b setTitle:[self.items objectAtIndex:i] forState:UIControlStateNormal];
        [b.titleLabel setFont:[UIFont systemFontOfSize:14]];
        if(i==0) [b setTitleColor:_titleHighLightColor forState:UIControlStateNormal];
        else [b setTitleColor:_titleNormalColor forState:UIControlStateNormal];
        [b.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [b setTag:i];
        [b addTarget:self action:@selector(choiceItem:) forControlEvents:UIControlEventTouchUpInside];
        [sv addSubview:b];
        
        [buttons addObject:b];
        
        //calculate the delta decrement value that moves toward left
        deltaTemp=coordinateX;
        NSNumber *n=[NSNumber numberWithFloat:deltaTemp];
        objc_setAssociatedObject(b, (__bridge const void *)(DeltaDecrementKey), n, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        coordinateX+=segmentWidth;
        
        //calculate the delta increment value that moves toward right
        deltaTemp=coordinateX-sv.bounds.size.width<=0?0:coordinateX-sv.bounds.size.width;
        n=[NSNumber numberWithFloat:deltaTemp];
        objc_setAssociatedObject(b, (__bridge const void *)(DeltaIncrementKey), n, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        if(i!=items.count-1){
            NoteLayer *separatorLine=[[NoteLayer alloc]init];
            [separatorLine setFrame:CGRectMake(coordinateX-_separatorLineWidth/2, 0, _separatorLineWidth, sv.bounds.size.height-_separatorLineWidth)];
            [separatorLine setBackgroundColor:_separatorColor.CGColor];
            [sv.layer addSublayer:separatorLine];
        }
    }
    
    [sv setContentSize:CGSizeMake(coordinateX, self.bounds.size.height)];
    
    if(_indicatorLineHeight==0) _indicatorLineHeight=DEFAULT_INDICATOR_LINE_HEIGHT;
    if(!_indicatorColor) _indicatorColor=[UIColor greenColor];
    
    CALayer *l=[[CALayer alloc]init];
    indicatorLine=l;
    [indicatorLine setFrame:CGRectMake(_separatorLineWidth/2, sv.bounds.size.height-_indicatorLineHeight, segmentWidth-_separatorLineWidth, _indicatorLineHeight)];
    [indicatorLine setBackgroundColor:_indicatorColor.CGColor];
    [sv.layer addSublayer:indicatorLine];
}

-(void)setIndicatorLineHeight:(CGFloat)indicatorLineHeight{
    if(indicatorLineHeight<0) return;
    _indicatorLineHeight=indicatorLineHeight==0?DEFAULT_INDICATOR_LINE_HEIGHT:indicatorLineHeight;
    [indicatorLine setFrame:CGRectMake((segmentWidth*self.currentIndex)+_separatorLineWidth/2, sv.bounds.size.height-_indicatorLineHeight, segmentWidth-_separatorLineWidth, _indicatorLineHeight)];
}

-(void)setIndicatorColor:(UIColor *)indicatorColor{
    if(!indicatorColor) return;
    _indicatorColor=indicatorColor;
    if(indicatorLine) [indicatorLine setBackgroundColor:_indicatorColor.CGColor];
}

-(void)setSeparatorLineWidth:(CGFloat)separatorLineWidth{
    if(separatorLineWidth<0) return;
    _separatorLineWidth=separatorLineWidth;
    
    [self prepare];
    [self setItems:_items];
}

-(void)setSeparatorColor:(UIColor *)separatorColor{
    if(!separatorColor) return;
    _separatorColor=separatorColor;
    
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:_separatorColor,ColorKey, nil];
    NSNotification *notif=[NSNotification notificationWithName:ChangeBackgroundColorNotif object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter]postNotification:notif];
}

-(void)setTitleNormalColor:(UIColor *)titleNormalColor{
    if(!titleNormalColor) return;
    _titleNormalColor=titleNormalColor;
    [self setButtonsColor];
}

-(void)setTitleHighLightColor:(UIColor *)titleHighLightColor{
    if(!titleHighLightColor) return;
    _titleHighLightColor=titleHighLightColor;
    [self setButtonsColor];
}

-(void)setHighLightColor:(UIColor *)highLightColor{
    if(!highLightColor) return;
    _highLightColor=highLightColor;
    for(HighLightButton *button in buttons) [button setHighLightColor:_highLightColor];
}

@end


@implementation NoteLayer

-(id)init{
    self=[super init];
    if(self){
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeBackgroundColor:) name:ChangeBackgroundColorNotif object:nil];
    }
    
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)changeBackgroundColor:(NSNotification *)notif{
    NSDictionary *userInfo=[notif userInfo];
    UIColor *color=[userInfo objectForKey:ColorKey];
    [self setBackgroundColor:color.CGColor];
}

@end
