//
//  MyCircle2Layout.m
//  OCCollectionViewDemo
//
//  Created by ZZ on 2019/11/29.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "MyCircle2Layout.h"

@interface MyCircle2Layout ()
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *layoutAttributes;

// arrays to keep track of insert, delete index paths
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *deleteIndexPaths;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *insertIndexPaths;

@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat radius;

//这个int值存储有多少个item
@property (nonatomic, assign) NSInteger itemCount;

@end

@implementation MyCircle2Layout

- (void)prepareLayout {
    [super prepareLayout];
    
    NSLog(@"第二个layout");

    CGSize size = self.collectionView.frame.size;

    //获取item的个数
    _itemCount = [self.collectionView numberOfItemsInSection:0];
    
    //先设定大圆的半径 取长和宽最短的
    _radius = MIN(size.width, size.height)/2;
    
    //计算大圆圆心位置
    _center = CGPointMake(size.width*.5, size.height*.4);
}

- (CGSize)collectionViewContentSize {
    return self.collectionView.frame.size;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    _layoutAttributes = [NSMutableArray array];
    
    for (NSInteger i = 0; i < _itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *layoutAttribute = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [_layoutAttributes addObject:layoutAttribute];
    }
    return _layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    //计算每个item中心的坐标
    //算出的x y值还要减去item自身的半径大小  设置边界可以去设置collectionView的约束达到效果
    float x = _center.x+cosf(2*M_PI/_itemCount*indexPath.item)*(_radius-self.itemSize.width*.5);
    float y = _center.y+sinf(2*M_PI/_itemCount*indexPath.item)*(_radius-self.itemSize.height*.5);
    
    attribute.center = CGPointMake(x, y);
    attribute.size = self.itemSize;
    
    return attribute;
}

#pragma mark - 动画效果

//步骤1
- (void)prepareForCollectionViewUpdates:(NSArray<UICollectionViewUpdateItem *> *)updateItems {
    // Keep track of insert and delete index paths
    [super prepareForCollectionViewUpdates:updateItems];
    
    self.deleteIndexPaths = [NSMutableArray array];
    self.insertIndexPaths = [NSMutableArray array];
    
    for (UICollectionViewUpdateItem *update in updateItems) {
        if (update.updateAction == UICollectionUpdateActionDelete) {
            [self.deleteIndexPaths addObject:update.indexPathBeforeUpdate];
        } else if (update.updateAction == UICollectionUpdateActionInsert) {
            [self.insertIndexPaths addObject:update.indexPathAfterUpdate];
        }
    }
    
    NSLog(@"%s %@", __func__, updateItems);
}

- (void)finalizeCollectionViewUpdates {
    [super finalizeCollectionViewUpdates];
    // release the insert and delete index paths
    self.deleteIndexPaths = nil;
    self.insertIndexPaths = nil;
}

/**
zz 2019-11-29: 更改之后的item数量调用次数

Note: name of method changed
Also this gets called for all visible cells (not just the inserted ones) and
even gets called when deleting cells!
*/
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    // Must call super
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
    if ([self.insertIndexPaths containsObject:itemIndexPath]) {
        // only change attributes on inserted cells
        if (!attributes) attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        
        // Configure attributes ...
        attributes.alpha = 0.0;
        attributes.center = CGPointMake(_center.x, _center.y);
    }
    
    NSLog(@"1 == %s %@", __func__, @(itemIndexPath.item));
    return attributes;
}

/**
 zz 2019-11-29: 更改之前的item数量调用次数
 
 Note: name of method changed
 Also this gets called for all visible cells (not just the deleted ones) and
 even gets called when inserting cells!
 */
- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    // So far, calling super hasn't been strictly necessary here, but leaving it in
    // for good measure
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    
    if ([self.deleteIndexPaths containsObject:itemIndexPath]) {
        // only change attributes on deleted cells
       if (!attributes) attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        
        // Configure attributes ...
        attributes.alpha = 0.0;
        attributes.center = CGPointMake(_center.x, _center.y);
        attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
    }
    
    NSLog(@"2 == %s %@", __func__, @(itemIndexPath.item));
    return attributes;
}

@end
