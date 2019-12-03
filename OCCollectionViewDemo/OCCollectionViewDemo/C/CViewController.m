//
//  CViewController.m
//  OCCollectionViewDemo
//
//  Created by ZZ on 2019/11/26.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "CViewController.h"
#import "MyPickLayout.h"
#import "Header.h"
#import "DViewController.h"

@interface CViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, MyPickLayoutProtocol>

@end

@implementation CViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MyPickLayout * layout = [MyPickLayout new];
    UICollectionView * collect  = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 320, 400) collectionViewLayout:layout];
    collect.delegate = self;
    collect.dataSource = self;
    collect.backgroundColor = [UIColor whiteColor];
    [collect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    [self.view addSubview:collect];
    
    [collect mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.edges.mas_equalTo(0);
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    label.text = [NSString stringWithFormat:@"我是第%ld行",(long)indexPath.row];
    label.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:label];
    return cell;
}

#pragma mark - MyPickLayoutProtocol

- (CGSize)myPickLayoutSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth, 100);
}

@end
