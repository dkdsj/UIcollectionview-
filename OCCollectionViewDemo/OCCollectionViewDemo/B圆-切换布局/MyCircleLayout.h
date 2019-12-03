//
//  MyCircleLayout.h
//  OCCollectionViewDemo
//
//  Created by ZZ on 2019/11/26.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MyCircleLayoutProtocol <NSObject>

@optional
- (CGSize)myCircleLayoutImageSizeForItemAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)myCircleLayoutColumnNumPerSection;

@end

@interface MyCircleLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<MyCircleLayoutProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
