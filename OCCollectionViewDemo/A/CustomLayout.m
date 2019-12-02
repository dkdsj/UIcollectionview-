//
//  CustomLayout.m
//  OCCollectionViewDemo
//
//  Created by ZZ on 2019/11/25.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "CustomLayout.h"

@implementation CustomLayout

#if 1

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributesArray = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *attributes in attributesArray)
    {
        [self applyLayoutAttributes:attributes];
    }
    return attributesArray;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];

    [self applyLayoutAttributes:attributes];

    return attributes;
}

//自定义方法
-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes
{
    // UICollectionElementKindSectionHeader
    // representedElementKind 为 nil, 表示这是一个cell，而不是 header 或者 decoration view
    if (attributes.representedElementKind == nil)
    {
        CGFloat width = [self collectionViewContentSize].width;
        CGFloat leftMargin = [self sectionInset].left;
        CGFloat rightMargin = [self sectionInset].right;

        NSUInteger itemsInSection = [[self collectionView] numberOfItemsInSection:attributes.indexPath.section];
        CGFloat firstXPosition = (width - (leftMargin + rightMargin)) / (2 * itemsInSection);
        CGFloat xPosition = firstXPosition + (2*firstXPosition*attributes.indexPath.item);

        attributes.center = CGPointMake(leftMargin + xPosition, attributes.center.y);
        attributes.frame = CGRectIntegral(attributes.frame);
    }
}

#else

NSString * const AFCollectionViewFlowLayoutBackgroundDecoration = @"DecorationIdentifier";

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributesArray = [super layoutAttributesForElementsInRect:rect];

    NSMutableArray *newAttributesArray = [NSMutableArray array];

    for (UICollectionViewLayoutAttributes *attributes in attributesArray) {
        [self applyLayoutAttributes:attributes];

        if (attributes.representedElementCategory == UICollectionElementCategorySupplementaryView) {
            UICollectionViewLayoutAttributes *newAttributes = [self layoutAttributesForDecorationViewOfKind:AFCollectionViewFlowLayoutBackgroundDecoration atIndexPath:attributes.indexPath];
            [newAttributesArray addObject:newAttributes];
        }
    }

    attributesArray = [attributesArray arrayByAddingObjectsFromArray:newAttributesArray];

    return attributesArray;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];

    //自定义的decoration view
    if ([decorationViewKind isEqualToString:AFCollectionViewFlowLayoutBackgroundDecoration])
    {
        UICollectionViewLayoutAttributes *tallestCellAttributes;
        //section有多少个cell
        NSInteger numberOfCellsInSection = [self.collectionView numberOfItemsInSection:indexPath.section];

        for (NSInteger i = 0; i < numberOfCellsInSection; i++) {
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForItem:i inSection:indexPath.section];

            //cell的attribute
            UICollectionViewLayoutAttributes *cellAttribtes = [self layoutAttributesForItemAtIndexPath:cellIndexPath];

            if (CGRectGetHeight(cellAttribtes.frame) > CGRectGetHeight(tallestCellAttributes.frame)) {
                //最高的cell
                tallestCellAttributes = cellAttribtes;
            }
        }

        //CGFloat decorationViewHeight = CGRectGetHeight(tallestCellAttributes.frame) + self.headerReferenceSize.height;

        //decoration view的高度
        CGFloat decorationViewHeight = CGRectGetHeight(tallestCellAttributes.frame) + self.sectionInset.top + self.sectionInset.bottom;

        layoutAttributes.size = CGSizeMake([self collectionViewContentSize].width, decorationViewHeight);
        layoutAttributes.center = CGPointMake([self collectionViewContentSize].width / 2.0f, tallestCellAttributes.center.y);
        layoutAttributes.frame = CGRectIntegral(layoutAttributes.frame);
        // 放在cell的后面
        layoutAttributes.zIndex = -1;
    }

    return layoutAttributes;
}

//自定义方法
-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes
{
    // UICollectionElementKindSectionHeader
    // representedElementKind 为 nil, 表示这是一个cell，而不是 header 或者 decoration view
    if (attributes.representedElementKind == nil)
    {
        CGFloat width = [self collectionViewContentSize].width;
        CGFloat leftMargin = [self sectionInset].left;
        CGFloat rightMargin = [self sectionInset].right;

        NSUInteger itemsInSection = [[self collectionView] numberOfItemsInSection:attributes.indexPath.section];
        CGFloat firstXPosition = (width - (leftMargin + rightMargin)) / (2 * itemsInSection);
        CGFloat xPosition = firstXPosition + (2*firstXPosition*attributes.indexPath.item);

        attributes.center = CGPointMake(leftMargin + xPosition, attributes.center.y);
        attributes.frame = CGRectIntegral(attributes.frame);
    }
}


-(void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];

    [updateItems enumerateObjectsUsingBlock:^(UICollectionViewUpdateItem *updateItem, NSUInteger idx, BOOL *stop) {
        if (updateItem.updateAction == UICollectionUpdateActionInsert)
        {
            [insertedSectionSet addObject:@(updateItem.indexPathAfterUpdate.section)];
        }
    }];
}

-(void)finalizeCollectionViewUpdates
{
    [super finalizeCollectionViewUpdates];

    [insertedSectionSet removeAllObjects];
}

-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingDecorationElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)decorationIndexPath
{
    //returning nil will cause a crossfade

    UICollectionViewLayoutAttributes *layoutAttributes;

    if ([elementKind isEqualToString:AFCollectionViewFlowLayoutBackgroundDecoration])
    {
        if ([insertedSectionSet containsObject:@(decorationIndexPath.section)])
        {
            layoutAttributes = [self layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:decorationIndexPath];
            layoutAttributes.alpha = 0.0f;
            layoutAttributes.transform3D = CATransform3DMakeTranslation(-CGRectGetWidth(layoutAttributes.frame), 0, 0);
        }
    }

    return layoutAttributes;
}

-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    //returning nil will cause a crossfade

    UICollectionViewLayoutAttributes *layoutAttributes;

    if ([insertedSectionSet containsObject:@(itemIndexPath.section)])
    {
        layoutAttributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        layoutAttributes.transform3D = CATransform3DMakeTranslation([self collectionViewContentSize].width, 0, 0);
    }

    return layoutAttributes;
}

#endif


@end
