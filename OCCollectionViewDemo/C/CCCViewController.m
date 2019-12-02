//
//  CCCViewController.m
//  OCCollectionViewDemo
//
//  Created by ZZ on 2019/11/28.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "CCCViewController.h"
#import "CCCTagLayout.h"
#import "CCCTagCell.h"

@interface CCCViewController ()<UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation CCCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //若为UICollectionViewLayout，itemSize和scrollDirection都需要自己写，下面的类继承自UICollectionViewLayout
    CCCTagLayout *layout = [CCCTagLayout new];
    layout.maximumInteritemSpacing = 10;
    
    CGFloat margin = (self.view.frame.size.width*0.25) / 2;
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:collection];
    
    collection.dataSource = self;
    collection.contentInset = UIEdgeInsetsMake(0, margin, 0, margin);
    collection.backgroundColor = [UIColor greenColor];
    [collection registerClass:[CCCTagCell class] forCellWithReuseIdentifier:@"CCCTagCell"];
    
    [collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.items = [NSMutableArray array];
    for (int i = 0; i < 103; i++) {
        NSString *str =  [self getRandomStringLen:arc4random_uniform(25)];
        [self.items addObject:str];
    }
    [collection reloadData];
}

#pragma mark - 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CCCTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CCCTagCell" forIndexPath:indexPath];
    cell.nameStr = self.items[indexPath.item];
    
    return cell;
}

//
// MARK: -  Action
//


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSString *rs = [self randomCreatChinese:arc4random_uniform(25)];
    rs = [self getRandomStringLen:arc4random_uniform(25)];
    NSLog(@"%@", rs);
}

#pragma mark - 生成随机数量的汉字

- (NSMutableString *)randomCreatChinese:(NSInteger)count{
    
    NSMutableString *randomChineseString =@"".mutableCopy;
    
    for(NSInteger i = 0; i < count; i++){
        
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

@end
