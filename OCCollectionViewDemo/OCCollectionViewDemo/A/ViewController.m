//
//  ViewController.m
//  OCCollectionViewDemo
//
//  Created by ZZ on 2019/7/24.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "ViewController.h"
#import "MyLayout.h"
#import "MyCollectionViewCell.h"
#import "Header.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MyLayoutProtocol>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) MyLayout *myLayout;
@property (nonatomic, strong) UICollectionView *cv;
@property (nonatomic, strong) NSMutableArray *rootItems;

@property (nonatomic, assign) NSInteger numCol;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.cv.contentInset = UIEdgeInsetsMake(40, 30, 20, 0);
    
    [[self initData] initView];
    
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (instancetype)initData {
    self.rootItems = [NSMutableArray array];
    self.numCol = 1;
    self.navigationItem.title = [NSString stringWithFormat:@"layout num %zd", _numCol];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (int i = 1 ; i < 50; i++) {
            int j = i%31;
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"image%d.jpeg", j]];
            [self.rootItems addObject:image];
        }
        self.myLayout.items = self.rootItems;
        [self.cv reloadData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:3 inSection:0];
            [self.cv selectItemAtIndexPath:indexPath animated:YES scrollPosition:(UICollectionViewScrollPositionBottom)];
            [self collectionView:self.cv didSelectItemAtIndexPath:indexPath];
        });
    });
    
    return self;
}

- (void)initView {
    NSLog(@"%f-%f-%f", kStatusBarHeight, kTabBarHeight, kNavBarHeight);

    [self.cv mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.view).offset(kStatusBarHeight+self.navigationController.navigationBar.frame.size.height+0);
        make.bottom.equalTo(self.view).offset(-kTabBarHeight);
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
    NSInteger num = arc4random() %5;
    num = num>0?num:num+1;
    self.navigationItem.title = [NSString stringWithFormat:@"layout num %zd", num];
    
    self.numCol = num;
    [self.cv reloadData];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.rootItems.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof MyCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionViewCell" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [self randomColor];
    [cell configModel:[NSString stringWithFormat:@"label %zd", indexPath.item]];
    
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
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


#pragma mark - MyLayoutProtocol

- (CGSize)myLayoutImageSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIImage *image = self.rootItems[indexPath.item];
    
//    NSString *floatStr = [NSString stringWithFormat:@"%.2f", height];
//    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
//    height = [[formatter numberFromString:floatStr] floatValue];
    
    return CGSizeMake(image.size.width, image.size.height);
}

- (NSInteger)myLayoutColumnNumPerSection {
    return self.numCol;
}

#pragma mark - Getter

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [UICollectionViewFlowLayout new];
        _layout.itemSize = CGSizeMake(100, hCv);
        _layout.minimumLineSpacing = 50;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.sectionHeadersPinToVisibleBounds = YES;

    }
    return _layout;
}

- (MyLayout *)myLayout {
    if (!_myLayout) {
        _myLayout = [MyLayout new];
        _myLayout.delegate = self;
//        _myLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        CGFloat inset = 5;
        CGFloat space = 5;
        _myLayout.sectionInset = UIEdgeInsetsMake(inset, inset, inset+kSafeBottom34, inset);
        _myLayout.minimumInteritemSpacing = space;
        _myLayout.minimumLineSpacing = space;
    }
    return _myLayout;
}

- (UICollectionView *)cv {
    if (!_cv) {
        _cv = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.myLayout];
        _cv.backgroundColor = [UIColor whiteColor];
        
        _cv.delegate = self;
        _cv.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _cv.dragInteractionEnabled = YES;
        } else {
            // Fallback on earlier versions
        }
        _cv.showsVerticalScrollIndicator = NO;
        
        [_cv registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"MyCollectionViewCell"];
        
        [self.view addSubview:_cv];
    }
    
    return _cv;
}


@end
