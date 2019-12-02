//
//  CCCTagLayout.h
//  OCCollectionViewDemo
//
//  Created by ZZ on 2019/11/28.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MyCCCLayoutProtocol <NSObject>

@optional

- (CGFloat)myCCCLayoutItemSpaceAtSectionIndex:(NSInteger)sectionIndex;
- (UIEdgeInsets)myCCCLayoutInsetAtSectionIndex:(NSInteger)sectionIndex;


@end

@interface CCCTagLayout : UICollectionViewFlowLayout

/**
 这个属性和 minimumInteritemSpacing 类似，用来设置两个同一列的相邻的cell之间的最大间距。
 相邻的cell之间的实际间距 spacing 总是要满足：

 minimumInteritemSpacing <= spacing <= maximumInteritemSpacing
 */
@property (nonatomic) CGFloat maximumInteritemSpacing;

@property (nonatomic, weak) id<MyCCCLayoutProtocol> delegate;


@end

NS_ASSUME_NONNULL_END
