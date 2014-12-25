//
//  ViewController.m
//  ZQHScrollableSegment
//
//  Created by lmwl123 on 12/23/14.
//  Copyright (c) 2014 zhaoqihao. All rights reserved.
//

#import "ViewController.h"
#import "ZQHScrollableSegment.h"

@interface ViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    __weak ZQHScrollableSegment *segment;
    __weak UITableView *lastTable;
    __weak UITableView *nextTable;
    NSArray *array;
}

@property (weak,nonatomic) UIScrollView *sv;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
//    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    [self prepareSegment];
    [self prepareScrollView];
}

-(void)prepareSegment{
    ZQHScrollableSegment *s=[[ZQHScrollableSegment alloc]init];
    segment=s;
    [self.view addSubview:segment];
    
    array=[NSArray arrayWithObjects:@"One",@"Two",@"Three",@"Four",@"Five",@"Six", nil];
    [segment setItems:array];
    [segment setViewController:self];
    [segment setSelectorName:@"choiceItem:"];
}

-(void)prepareScrollView{
    UIScrollView *s=[[UIScrollView alloc]initWithFrame:CGRectMake(0, segment.bounds.size.height, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-segment.bounds.size.height-64)];
    self.sv=s;
    [self.sv setDelegate:self];
    [self.sv setPagingEnabled:YES];
    [self.sv setBounces:NO];
    [self.sv setShowsHorizontalScrollIndicator:NO];
    [self.sv setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:s];
    [self prepareTableView];
}

-(void)prepareTableView{
    CGFloat coordinateX=0;
    for(int i=0;i<array.count;i++){
        UITableView *t=[[UITableView alloc]initWithFrame:CGRectMake(coordinateX, 0, self.sv.bounds.size.width, self.sv.bounds.size.height)];
        [t setTag:i];
        [t setDelegate:self];
        [t setDataSource:self];
        [t registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [self.sv addSubview:t];
        coordinateX+=self.sv.bounds.size.width;
    }
    
    [self.sv setContentSize:CGSizeMake(coordinateX, self.sv.bounds.size.height)];
}

-(void)choiceItem:(NSNumber *)index{
    [self.sv setContentOffset:CGPointMake(index.integerValue * self.sv.bounds.size.width, 0) animated:YES];
}

#pragma mark - ScrollView Delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if([scrollView isKindOfClass:[UITableView class]]) return;
    CGFloat w=scrollView.bounds.size.width;
    NSInteger currentPage=floor((scrollView.contentOffset.x-w/2.0)/w)+1;
    [segment moveToIndex:currentPage];
}

#pragma mark - TableView DataSource and Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    NSInteger tag=[tableView tag];
    [cell.textLabel setText:[NSString stringWithFormat:@"This is a item %ld",(long)tag+1]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

@end
