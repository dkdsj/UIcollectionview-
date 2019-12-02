//
//  CCCTagLayout.m
//  OCCollectionViewDemo
//
//  Created by ZZ on 2019/11/28.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "CCCTagLayout.h"

//https://blog.csdn.net/sinat_39362502/article/details/80900984
@interface UICollectionViewLayoutAttributes (LeftAligned)
- (void)leftAlignFrameWithSectionInset:(UIEdgeInsets)sectionInset;
@end
 
@implementation UICollectionViewLayoutAttributes (LeftAligned)
- (void)leftAlignFrameWithSectionInset:(UIEdgeInsets)sectionInset {
    CGRect frame = self.frame;
    frame.origin.x = sectionInset.left;
    self.frame = frame;
}
@end


@interface CCCTagLayout ()
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *layoutAttributes;
@end

@implementation CCCTagLayout

#if 0
#pragma mark - UICollectionViewLayout
 
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *originalAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *updatedAttributes = [NSMutableArray arrayWithArray:originalAttributes];
    
    for (UICollectionViewLayoutAttributes *attributes in originalAttributes) {
        if (!attributes.representedElementKind) {
            NSUInteger index = [updatedAttributes indexOfObject:attributes];
            updatedAttributes[index] = [self layoutAttributesForItemAtIndexPath:attributes.indexPath];
        }
    }
 
    return updatedAttributes;
}
 
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* currentItemAttributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
    UIEdgeInsets sectionInset = [self evaluatedSectionInsetForItemAtIndex:indexPath.section];
 
    BOOL isFirstItemInSection = (indexPath.item == 0);
    CGFloat layoutWidth = CGRectGetWidth(self.collectionView.frame) - sectionInset.left - sectionInset.right;
 
    if (isFirstItemInSection) {
        [currentItemAttributes leftAlignFrameWithSectionInset:sectionInset];
        return currentItemAttributes;
    }
 
    NSIndexPath* previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section];
    CGRect previousFrame = [self layoutAttributesForItemAtIndexPath:previousIndexPath].frame;
    CGFloat previousFrameRightPoint = previousFrame.origin.x + previousFrame.size.width;
    CGRect currentFrame = currentItemAttributes.frame;
    CGRect strecthedCurrentFrame = CGRectMake(sectionInset.left,
                                              currentFrame.origin.y,
                                              layoutWidth,
                                              currentFrame.size.height);
    // if the current frame, once left aligned to the left and stretched to the full collection view
    // width intersects the previous frame then they are on the same line
    BOOL isFirstItemInRow = !CGRectIntersectsRect(previousFrame, strecthedCurrentFrame);
 
    if (isFirstItemInRow) {
        // make sure the first item on a line is left aligned
        [currentItemAttributes leftAlignFrameWithSectionInset:sectionInset];
        return currentItemAttributes;
    }
 
    CGRect frame = currentItemAttributes.frame;
    frame.origin.x = previousFrameRightPoint + [self evaluatedMinimumInteritemSpacingForSectionAtIndex:indexPath.section];
    currentItemAttributes.frame = frame;
    return currentItemAttributes;
}
 
- (CGFloat)evaluatedMinimumInteritemSpacingForSectionAtIndex:(NSInteger)sectionIndex {
    if ([self.delegate respondsToSelector:@selector(myCCCLayoutItemSpaceAtSectionIndex:)]) {
        return [self.delegate myCCCLayoutItemSpaceAtSectionIndex:sectionIndex];
    } else {
        return self.minimumInteritemSpacing;
    }
}
 
- (UIEdgeInsets)evaluatedSectionInsetForItemAtIndex:(NSInteger)sectionIndex {
    if ([self.delegate respondsToSelector:@selector(myCCCLayoutInsetAtSectionIndex:)]) {
        return [self.delegate myCCCLayoutInsetAtSectionIndex:sectionIndex];
    } else {
        return self.sectionInset;
    }
}

//
// MARK: -  <#name#>
//

#else

- (void)prepareLayout {
    self.maximumInteritemSpacing = 10;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    //使用系统帮我们计算好的结果。
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    [self logAttribute:attributes];

    //第0个cell没有上一个cell，所以从1开始
    for(int i = 1; i < [attributes count]; ++i) {
        
        //这里 UICollectionViewLayoutAttributes 的排列总是按照 indexPath的顺序来的。
        UICollectionViewLayoutAttributes *curAttr = attributes[i];
        UICollectionViewLayoutAttributes *preAttr = attributes[i-1];
   
        NSInteger origin = CGRectGetMaxX(preAttr.frame);
        //根据  maximumInteritemSpacing 计算出的新的 x 位置
        CGFloat targetX = origin +  self.maximumInteritemSpacing;
        // 只有系统计算的间距大于  maximumInteritemSpacing 时才进行调整
        if (CGRectGetMinX(curAttr.frame) > targetX) {
            // 换行时不用调整
            if (targetX + CGRectGetWidth(curAttr.frame) < self.collectionViewContentSize.width) {
                CGRect frame = curAttr.frame;
                frame.origin.x = targetX;
                curAttr.frame = frame;
            }
        }
    }
    return attributes;
}

//- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
//
//    NSArray *array = [super layoutAttributesForElementsInRect:rect];
//
//    _layoutAttributes = [NSMutableArray arrayWithArray:array];
//
//    [self logAttribute:array];
//
//    return _layoutAttributes;
//}

- (void)logAttribute:(NSArray<UICollectionViewLayoutAttributes *> *)attributes {
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        NSLog(@"[%zd] itemSize:%@", attribute.indexPath.item, NSStringFromCGSize(attribute.size));
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //使用系统帮我们计算好的结果
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];


    return attributes;
}

#endif

@end
