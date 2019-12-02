//
//  MyPickLayout.h
//  OCCollectionViewDemo
//
//  Created by ZZ on 2019/11/26.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MyPickLayoutProtocol <NSObject>

@required
- (CGSize)myPickLayoutSizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSInteger)myCircleLayoutColumnNumPerSection;

@end

@interface MyPickLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<MyPickLayoutProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
