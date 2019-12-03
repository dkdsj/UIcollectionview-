//
//  DViewController.m
//  OCCollectionViewDemo
//
//  Created by ZZ on 2019/11/26.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "DViewController.h"
#import "MyCollectionViewCell.h"
#import "MoreSectionMoreColumnLayout.h"
#import "Header.h"

@interface DViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MoreSectionMoreColumnLayoutDelegate>

@property (nonatomic, strong) MoreSectionMoreColumnLayout *mmLayout;
@property (nonatomic, strong) UICollectionView *cv;
@property (nonatomic, strong) NSMutableArray *rootItems;


@end

@implementation DViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.cv.contentInset = UIEdgeInsetsMake(40, 30, 20, 0);
    
    [[self initData] initView];
    
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (instancetype)initData {
    self.rootItems = [NSMutableArray array];

    
    return self;
}

- (void)initView {
    [self.cv mas_makeConstraints:^(MASConstraintMaker *make) {
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

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 6;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 1 || section == 3) {
        return 17;
    }
    
    return 2;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof MyCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionViewCell" forIndexPath:indexPath];
    
    [cell configModel:[NSString stringWithFormat:@"label %zd-%zd", indexPath.section, indexPath.item]];
    
    return cell;
}

#pragma mark - MoreSectionMoreColumnLayoutDelegate

- (NSInteger)numberOfSection {
    return [self numberOfSectionsInCollectionView:_cv];
}

- (NSInteger)numberOfColumnInSectionAtIndex:(NSInteger)section {
    if (section == 1) {
        return 2;
    }
    else if (section == 3) {
        return 3;
    }
    
    return 1;
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 || indexPath.section == 3) {
        // [40,160)随机数
        CGFloat height = 40 + arc4random() % (160 - 40 + 1);
        
        return CGSizeMake(_cv.bounds.size.width, height);
    }
    
    return CGSizeMake(_cv.bounds.size.width, 100);
}

- (CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 1 || section == 3) {
        return 10;
    }
    
    return 4.0;
}

- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 1 || section == 3) {
        return 10;
    }
    
    return 0.0;
}

- (UIEdgeInsets)contentInsetOfSectionAtIndex:(NSInteger)section {
    if (section == 1 || section == 3) {
        return UIEdgeInsetsMake(0, 10, 10, 10);
    }
    
    return UIEdgeInsetsZero;
}

#pragma mark - Getter

- (MoreSectionMoreColumnLayout *)mmLayout {
    if (!_mmLayout) {
        _mmLayout = [MoreSectionMoreColumnLayout new];
        _mmLayout.delegate = self;
        
        CGFloat inset = 5;
        CGFloat space = 5;
        _mmLayout.sectionInset = UIEdgeInsetsMake(inset, inset, inset+kSafeBottom34, inset);
        _mmLayout.minimumInteritemSpacing = space;
        _mmLayout.minimumLineSpacing = space;
    }
    return _mmLayout;
}

- (UICollectionView *)cv {
    if (!_cv) {
        _cv = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.mmLayout];
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
