//
//  MyLayout.m
//  OCCollectionViewDemo
//
//  Created by ZZ on 2019/11/25.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "MyLayout.h"
#import "Header.h"

@interface MyLayout ()
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *layoutAttributes;
@property (nonatomic, assign) CGFloat hLayout;//最长的列高度
@end

@implementation MyLayout

/**
 减去collectionView.contentInset
 */
- (CGSize)collectionViewContentSize {
    NSLog(@"collectionViewContentSize:%f", _hLayout);
    
    return CGSizeMake(kScreenWidth-self.collectionView.contentInset.left-self.collectionView.contentInset.right, _hLayout);
}

/**
 UICollectionElementKindSectionHeader
 */
//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//
//}
//- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
//
//}
//- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
//
//}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    if (CGRectGetHeight(newBounds) != CGRectGetHeight(oldBounds)) {
        return YES;
    }
        return NO;
}

- (void)prepareLayout {
    [super prepareLayout];
        
    NSLog(@"log: prepareLayout");
    
    //几列
    NSInteger numberOfColumms = [self.delegate myLayoutColumnNumPerSection];

    CGFloat colHeights[numberOfColumms];
    for (int i = 0; i < numberOfColumms; i++) {
        colHeights[i] = 0;
    }
    
    CGFloat layoutInsetWidth = self.sectionInset.left+self.sectionInset.right;
    CGFloat cvContentInsetWidth = self.collectionView.contentInset.left+self.collectionView.contentInset.right;
    
    //cell width
    CGFloat itemWidth = (kScreenWidth-((numberOfColumms-1)*self.minimumInteritemSpacing)-layoutInsetWidth-cvContentInsetWidth)/numberOfColumms;
    
    _layoutAttributes = [NSMutableArray array];
    
    for (NSInteger i = 0; i < _items.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        NSLog(@" ");
        
        //判断第N列高度最小
        NSInteger minHeightColumn = 0;
        CGFloat hMin = colHeights[0];
        
        for (int i = 0; i < numberOfColumms; i++) {
            CGFloat tmpH = colHeights[i];
            NSLog(@"hMin:%f ch[%d]:%f index:%zd", hMin, i, tmpH, minHeightColumn);
            if (tmpH < hMin) {
                minHeightColumn = i;
                hMin = tmpH;
            }
        }
        
        //cell height
        CGSize imageSize = [self.delegate myLayoutImageSizeForItemAtIndexPath:indexPath];
        CGFloat itemHeight = itemWidth*imageSize.height/imageSize.width;
        
        //最小高度列加上item后的高度更新
        colHeights[minHeightColumn] = colHeights[minHeightColumn]+itemHeight+self.minimumLineSpacing;
        
        CGFloat x = self.sectionInset.left+itemWidth*minHeightColumn+self.minimumLineSpacing*minHeightColumn;
        CGFloat y = self.sectionInset.top+colHeights[minHeightColumn]-itemHeight;
        
        //布局属性
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attribute.frame = CGRectMake(x, y, itemWidth, itemHeight);
        
        _hLayout = colHeights[minHeightColumn]+self.sectionInset.top+self.sectionInset.bottom;
        
        [_layoutAttributes addObject:attribute];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSLog(@"log: layoutAttributesForElementsInRect:%@", NSStringFromCGRect(rect));

    return _layoutAttributes;
}

@end
