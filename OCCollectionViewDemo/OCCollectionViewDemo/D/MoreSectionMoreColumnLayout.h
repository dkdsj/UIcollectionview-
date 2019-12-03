//
//  MoreSectionMoreColumnLayout.h
//  zhancha
//
//  Created by ZZ on 2019/12/2.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MoreSectionMoreColumnLayoutDelegate <NSObject>

@optional
- (CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger)section;  // 行间距
- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section; // 列间距
- (UIEdgeInsets)contentInsetOfSectionAtIndex:(NSInteger)section;        // sectionInset

@required
- (NSInteger)numberOfSection;   // section的数量
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath;  // cell的大小
- (NSInteger)numberOfColumnInSectionAtIndex:(NSInteger)section; // section的列数

@end

@interface MoreSectionMoreColumnLayout : UICollectionViewFlowLayout//UICollectionViewLayout

@property (nonatomic, weak) id<MoreSectionMoreColumnLayoutDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
