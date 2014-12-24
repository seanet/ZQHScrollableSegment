//
//  ViewController.m
//  ZQHScrollableSegment
//
//  Created by lmwl123 on 12/23/14.
//  Copyright (c) 2014 zhaoqihao. All rights reserved.
//

#import "ViewController.h"
#import "ZQHScrollableSegment.h"

@interface ViewController (){
    ZQHScrollableSegment *segment;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    segment=[[ZQHScrollableSegment alloc]init];
    [self.view addSubview:segment];

    NSArray *array=[NSArray arrayWithObjects:@"One",@"Two",@"Three",@"Four",@"Five",@"Six", nil];
    [segment setItems:array];
    
    [segment setViewController:self];
    [segment setSelectorName:@"choiceItem:"];
}

- (IBAction)click:(id)sender {
    [segment setTitleHighLightColor:[UIColor orangeColor]];
}

-(void)choiceItem:(NSNumber *)index{
    NSLog(@"%@",index);
}

@end
