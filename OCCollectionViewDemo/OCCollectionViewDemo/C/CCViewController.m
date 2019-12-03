//
//  CCViewController.m
//  OCCollectionViewDemo
//
//  Created by ZZ on 2019/11/28.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "CCViewController.h"
#import "CCLineLayout.h"

@interface CCViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, assign) NSInteger numItem;
@end

@implementation CCViewController

static  NSString *ZWCellID = @"cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.numItem = 5;
    
    //若为UICollectionViewLayout，itemSize和scrollDirection都需要自己写，下面的类继承自UICollectionViewLayout
    CCLineLayout *layout = [[CCLineLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.frame.size.width*.75, self.view.frame.size.height*0.75);
//    layout.minimumInteritemSpacing = 20;
//    layout.minimumLineSpacing = 15;
    
    CGFloat margin = (self.view.frame.size.width*0.25) / 2;
    CGRect rect = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width * 0.6);
    
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:collection];
    collection.dataSource = self;
    collection.delegate = self;
    collection.contentInset = UIEdgeInsetsMake(0, margin, 0, margin);
    collection.backgroundColor = [UIColor greenColor];
    [collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ZWCellID];
}

#pragma mark - 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.numItem;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZWCellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item%2==0) {
        self.numItem--;
        [collectionView performBatchUpdates:^{
            [collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:nil];
    } else {
        self.numItem++;
        [collectionView performBatchUpdates:^{
            [collectionView insertItemsAtIndexPaths:@[indexPath]];
        } completion:nil];
    }
}

@end
