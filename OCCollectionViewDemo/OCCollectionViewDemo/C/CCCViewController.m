//
//  CCCViewController.m
//  OCCollectionViewDemo
//
//  Created by ZZ on 2019/11/28.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "CCCViewController.h"
#import "CCCTagCell.h"
#import "CCCTagLayout.h"
#import "CCCTagReuseView.h"
#import "CCCTagView.h"

@interface CCCViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, MyCCCLayoutProtocol>
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) CCCTagLayout *myLayout;
@property (nonatomic, strong) UICollectionView *cv;

@property (nonatomic, strong) CCCTagView *cccTv;
@end

@implementation CCCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
//    [self.cv mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(0);
//    }];
    self.cccTv = [CCCTagView new];
    [self.view addSubview:_cccTv];
    
    UIView *vTop = [UIView new];vTop.backgroundColor = [UIColor systemBlueColor];[self.view addSubview:vTop];
    UIView *vBottom = [UIView new];vBottom.backgroundColor = [UIColor purpleColor];[self.view addSubview:vBottom];
    [vTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    [self.cccTv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(vBottom.mas_top);
        make.top.equalTo(vTop.mas_bottom);
    }];
    [vBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(kTabBarHeight);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
    [self getData];
//    [self.cv reloadData];
}

- (void)getData {
    self.items = [NSMutableArray array];
    
    for (int i = 0; i < 5; i++) {
        int column = arc4random_uniform(25)+1;
        NSMutableArray *array = [NSMutableArray array];
        
        for (int j = 0; j < column; j++) {
            NSString *str =  [self randomCreatChinese:arc4random_uniform(6)+1];
            [array addObject:[NSString stringWithFormat:@"%d-%@-%d", i, str, i]];
        }
        
        [self.items addObject:array];
    }
    
    [self.cccTv cccTageViewConfig:self.items];
}

#pragma mark - MyCCCLayoutProtocol

// 用协议传回 item 的内容,用于计算 item 宽度
- (NSString *)collectionViewItemSizeWithIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.items[indexPath.section];
    NSString *text = array[indexPath.item];
    return text;
}

#pragma mark - 数据源方法

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.items.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.items[section] count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CCCTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CCCTagCell" forIndexPath:indexPath];
    
    NSArray *array = self.items[indexPath.section];
    cell.nameStr = array[indexPath.item];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        CCCTagReuseView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter" forIndexPath:indexPath];
        view.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:.4];
        return view;
    } else if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CCCTagReuseView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CCCTagReuseView" forIndexPath:indexPath];
        [view configTagReuseView:[NSString stringWithFormat:@"section %zd", indexPath.section]];
        return view;
    }
    return nil;
}


#pragma mark - 生成随机数量的汉字

- (NSMutableString *)randomCreatChinese:(NSInteger)len{
    
    NSMutableString *randomChineseString =@"".mutableCopy;
    
    for(NSInteger i = 0; i < len; i++){
        
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        //随机生成汉字高位
        int a = 0xFE, b = 0xA1;
        NSInteger randomH =0xA1+arc4random()%(a-b+1);
        
        //随机生成汉子低位
        NSInteger randomL =0xB0+arc4random()%(0xF7-0xB0+1);
        
        //组合生成随机汉字
        NSInteger number = (randomH<<8)+randomL;
        
        NSData *data = [NSData dataWithBytes:&number length:2];
        NSString *string = [[NSString alloc] initWithData:data encoding:gbkEncoding];
        
        [randomChineseString appendString:string];
    }
    return randomChineseString;
}

- (NSString *)getRandomStringLen:(NSInteger)len {
    if (len==0) {
        len = 2;
    }
    
    char data[len];
    for (int x = 0; x < len;data[x++] = (char)('A' + (arc4random_uniform(26))));
    NSString *randomStr = [[NSString alloc] initWithBytes:data length:len encoding:NSUTF8StringEncoding];
    NSString *string = [NSString stringWithFormat:@"%@",randomStr];
    return string;
}

#pragma mark - Getter

- (CCCTagLayout *)myLayout {
    if (!_myLayout) {
        _myLayout = [CCCTagLayout new];
        _myLayout.delegate = self;
        
        //自定义layout初始化
//        _myLayout.lineSpacing = 8.0;
//        _myLayout.interitemSpacing = 10;
        _myLayout.headerViewHeight = 35;
        _myLayout.footerViewHeight = 5;
//        _myLayout.itemInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
    }
    return _myLayout;
}

- (UICollectionView *)cv {
    if (!_cv) {
        _cv = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.myLayout];
        _cv.backgroundColor = [UIColor whiteColor];
        
        _cv.delegate = self;
        _cv.dataSource = self;
        _cv.showsVerticalScrollIndicator = NO;
        
        [_cv registerClass:[CCCTagCell class] forCellWithReuseIdentifier:@"CCCTagCell"];
        [_cv registerClass:[CCCTagReuseView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CCCTagReuseView"];
        [_cv registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter"];
        
        [self.view addSubview:_cv];
    }
    
    return _cv;
}


@end
