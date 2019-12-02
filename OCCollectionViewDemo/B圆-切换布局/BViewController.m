//
//  BViewController.m
//  OCCollectionViewDemo
//
//  Created by ZZ on 2019/11/26.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "BViewController.h"
#import "MyCircleLayout.h"
#import "MyCircle2Layout.h"

#import "Header.h"
#import "MyCollectionViewCell.h"

@interface BViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MyCircleLayoutProtocol>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) MyCircleLayout *myLayout;
@property (nonatomic, strong) MyCircle2Layout *myLayout2;
@property (nonatomic, strong) UICollectionView *cv;
@property (nonatomic, strong) NSMutableArray *rootItems;

@end

@implementation BViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [[self initData] initView];
    
    /**
     直接更改collectionView的collectionViewLayout属性可以立即切换布局。
     如果通过setCollectionViewLayout:animated:，则可以在切换布局的同时，使用动画来过渡。
     self.cv setCollectionViewLayout:<#(nonnull UICollectionViewLayout *)#> animated:<#(BOOL)#>
     */
}

- (instancetype)initData {
    self.rootItems = [NSMutableArray array];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i = 1 ; i < 5; i++) {
            //int j = i%31;
            //UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"image%d.jpeg", j]];
            [self.rootItems addObject:@(i)];
        }
        [self.cv reloadData];
    });
    
    return self;
}

- (void)initView {
    [self.cv mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.edges.mas_equalTo(0);
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
}

- (UIColor *)randomColor {
    NSInteger aRedValue = arc4random() %255;
    NSInteger aGreenValue = arc4random() %255;
    NSInteger aBlueValue = arc4random() %255;
    UIColor *randColor = [UIColor colorWithRed:aRedValue/255.0f green:aGreenValue/255.0f blue:aBlueValue /255.0f alpha:1.0f];
    
    return randColor;
}

- (IBAction)changeLayoutNumAction:(UIBarButtonItem *)sender {
    
    //切换布局
    static BOOL bb = YES;
    if (bb) {
        [self.cv setCollectionViewLayout:self.myLayout animated:NO];
    } else {
        [self.cv setCollectionViewLayout:self.myLayout2 animated:NO];
    }
    bb = !bb;
    return;

    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_rootItems.count-1 inSection:0];
    [_rootItems removeObjectAtIndex:indexPath.item];
    
    [self.cv performBatchUpdates:^{
        [self.cv deleteItemsAtIndexPaths:@[indexPath]];
    } completion:nil];
}
- (IBAction)addItem:(UIBarButtonItem *)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [_rootItems addObject:@(0)];
    
    [self.cv performBatchUpdates:^{
        [self.cv insertItemsAtIndexPaths:@[indexPath]];
    } completion:nil];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.rootItems.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [self randomColor];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = self.myLayout.itemSize.width*.5;
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(9.0)) {
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath API_AVAILABLE(ios(9.0)) {
    [collectionView reloadItemsAtIndexPaths:[collectionView indexPathsForVisibleItems]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did select item section:%zd item:%zd", indexPath.section, indexPath.item);
    
    [_rootItems removeObjectAtIndex:indexPath.item];
    [collectionView performBatchUpdates:^{
        [collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:nil];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


#pragma mark - MyCircleLayoutProtocol

- (CGSize)myCircleLayoutImageSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UIImage *image = self.rootItems[indexPath.item];
    
//    NSString *floatStr = [NSString stringWithFormat:@"%.2f", height];
//    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
//    height = [[formatter numberFromString:floatStr] floatValue];
    
//    return CGSizeMake(image.size.width, image.size.height);
    return CGSizeMake(50, 50);
}

- (NSInteger)myCircleLayoutColumnNumPerSection {
    return 1;
}

#pragma mark - Getter

- (MyCircleLayout *)myLayout {
    if (!_myLayout) {
        _myLayout = [MyCircleLayout new];
        _myLayout.delegate = self;
        _myLayout.itemSize = CGSizeMake(100, 100);
        
        CGFloat inset = 5;
        CGFloat space = 5;
        _myLayout.sectionInset = UIEdgeInsetsMake(inset, inset, inset+kSafeBottom34, inset);
        _myLayout.minimumInteritemSpacing = space;
        _myLayout.minimumLineSpacing = space;
    }
    return _myLayout;
}

- (MyCircle2Layout *)myLayout2 {
    if (!_myLayout2) {
        _myLayout2 = [MyCircle2Layout new];
        _myLayout2.itemSize = CGSizeMake(100, 100);
        
        CGFloat inset = 5;
        CGFloat space = 5;
        _myLayout2.sectionInset = UIEdgeInsetsMake(inset, inset, inset+kSafeBottom34, inset);
        _myLayout2.minimumInteritemSpacing = space;
        _myLayout2.minimumLineSpacing = space;
    }
    return _myLayout2;
}

- (UICollectionView *)cv {
    if (!_cv) {
        _cv = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.myLayout];
        _cv.backgroundColor = [UIColor whiteColor];
        
        _cv.delegate = self;
        _cv.dataSource = self;
        
        [_cv registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        
        [self.view addSubview:_cv];
    }
    
    return _cv;
}

@end
