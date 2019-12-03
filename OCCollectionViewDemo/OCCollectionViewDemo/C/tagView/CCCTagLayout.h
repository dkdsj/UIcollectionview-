//
//  CCCTagLayout.h
//  OCCollectionViewDemo
//
//  Created by ZZ on 2019/11/28.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MyCCCLayoutProtocol <NSObject>

@required

// 用协议传回 item 的内容,用于计算 item 宽度
- (NSString *)collectionViewItemSizeWithIndexPath:(NSIndexPath *)indexPath;

@optional

// 用协议传回 headerSize 的 size
- (CGSize)collectionViewDynamicHeaderSizeWithIndexPath:(NSIndexPath *)indexPath;
// 用协议传回 footerSize 的 size
- (CGSize)collectionViewDynamicFooterSizeWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface CCCTagLayout : UICollectionViewFlowLayout

// item 的行距（默认8.0）
@property (nonatomic, assign) CGFloat lineSpacing;
// item 的间距 （默认8.0）
@property (nonatomic, assign) CGFloat interitemSpacing;
// header 高度（默认0.0）
@property (nonatomic, assign) CGFloat headerViewHeight;
// footer 高度（默认0.0）
@property (nonatomic, assign) CGFloat footerViewHeight;
// item 高度 (默认30)
@property (nonatomic, assign) CGFloat itemHeight;
// footer 边距缩进（默认UIEdgeInsetsZero）
@property (nonatomic, assign) UIEdgeInsets footerInset;
// header 边距缩进（默认UIEdgeInsetsZero）
@property (nonatomic, assign) UIEdgeInsets headerInset;
// item 边距缩进（默认UIEdgeInsetsZero）
@property (nonatomic, assign) UIEdgeInsets itemInset;
// item Label Font（默认系统字体15）
@property (nonatomic, copy) UIFont *labelFont;

@property (nonatomic, weak) id<MyCCCLayoutProtocol> delegate;

- (instancetype)initWithHeaderViewHeight:(CGFloat)headerViewHeight
                        footerViewHeight:(CGFloat)footerViewHeight
                               itemSpace:(CGFloat)itemSpace
                               lineSpace:(CGFloat)lineSpace
                              itemHeight:(CGFloat)itemHeight
                               itemInset:(UIEdgeInsets)itemInset
                             headerInset:(UIEdgeInsets)headerInset
                             footerInset:(UIEdgeInsets)footerInset
                               labelFont:(UIFont *)labelFont ;
@end

NS_ASSUME_NONNULL_END
