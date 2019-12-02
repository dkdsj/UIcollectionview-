//
//  MyLayout.h
//  OCCollectionViewDemo
//
//  Created by ZZ on 2019/11/25.
//  Copyright © 2019 ZZ. All rights reserved.
//


#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@protocol MyLayoutProtocol <NSObject>

@required

//图片的大小
- (CGSize)myLayoutImageSizeForItemAtIndexPath:(NSIndexPath *)indexPath;

//多少列
- (NSInteger)myLayoutColumnNumPerSection;

@end

@interface MyLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, weak) id<MyLayoutProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
