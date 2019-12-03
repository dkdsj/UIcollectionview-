//
//  CCLineLayout.m
//  OCCollectionViewDemo
//
//  Created by ZZ on 2019/11/28.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "CCLineLayout.h"

@implementation CCLineLayout

/**
 * 用来做布局的初始化操作（不建议在init方法中进行布局的初始化操作）
 */
- (void)prepareLayout {
    [super prepareLayout];
    //水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;

}

/**
 * 当collectionView的显示范围发生改变的时候，是否需要重新刷新布局
 * 一旦重新刷新布局，就会重新调用下面的方法：
 * 1.prepareLayout
 * 2.layoutAttributesForElementsInRect:方法
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}


/**
 * 这个方法的返回值是一个数组（数组里面存放着rect范围内所有元素的布局属性）
 * 这个方法的返回值决定了rect范围内所有元素的排布（frame）
 */
//需要在viewController中使用上ZWLineLayout这个类后才能重写这个方法！！
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    //让父类布局好样式
    NSArray *arr = [super layoutAttributesForElementsInRect:rect];
    //计算出collectionView的中心的位置
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    /**
     * 1.一个cell对应一个UICollectionViewLayoutAttributes对象
     * 2.UICollectionViewLayoutAttributes对象决定了cell的frame
     */
    for (UICollectionViewLayoutAttributes *attributes in arr) {
#if 0
        //cell的中心点距离collectionView的中心点的距离，注意ABS()表示绝对值
        CGFloat delta = ABS(attributes.center.x - centerX);
        //设置缩放比例
        CGFloat scale = 1.0 - delta / self.collectionView.frame.size.width;
        NSLog(@"delta:%f scale:%f", delta, scale);
        
        //设置cell滚动时候缩放的比例
        attributes.transform = CGAffineTransformMakeScale(scale, scale);
#else
        //这个效果比较好
        
        CGFloat distance = fabs(attributes.center.x - centerX);
        //移动的距离和屏幕宽度的的比例
        CGFloat apartScale = distance/self.collectionView.bounds.size.width;
        //把卡片移动范围固定到 -π/4到 +π/4这一个范围内
        CGFloat scale = fabs(cos(apartScale * M_PI/4));
        //设置cell的缩放 按照余弦函数曲线 越居中越趋近于1
        attributes.transform = CGAffineTransformMakeScale(scale, scale);
#endif
    }
    
    return arr;
}

/**
 * 这个方法的返回值，就决定了collectionView停止滚动时的偏移量
 * proposedContentOffset: 手指离开屏幕时CollectionView的offset
 * velocity:手指离开屏幕时CollectionView滑动的速度 有正负之分 反向为负的
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    // 计算出最终显示的矩形框
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = proposedContentOffset.x;
    rect.size = self.collectionView.frame.size;
    
    NSLog(@"%@-%@", NSStringFromCGPoint(proposedContentOffset), NSStringFromCGPoint(velocity));
    
    //获得super已经计算好的布局的属性
    NSArray *arr = [super layoutAttributesForElementsInRect:rect];
    
    //计算collectionView最中心点的x值
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in arr) {
        if (ABS(minDelta) > ABS(attrs.center.x - centerX)) {
            minDelta = attrs.center.x - centerX;
        }
    }
    proposedContentOffset.x += minDelta;
    return proposedContentOffset;
}

/**
 喵神的 https://onevcat.com/2012/08/advanced-collection-view/
 */
- (CGPoint)mmftargetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    //proposedContentOffset是没有对齐到网格时本来应该停下的位置
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];

    //对当前屏幕中的UICollectionViewLayoutAttributes逐个与屏幕中心进行比较，找出最接近中心的一个
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

@end
