//
//  MyPickLayout.m
//  OCCollectionViewDemo
//
//  Created by ZZ on 2019/11/26.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "MyPickLayout.h"

@implementation MyPickLayout

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height*[self.collectionView numberOfItemsInSection:0]);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<UICollectionViewLayoutAttributes *> *attributes = [NSMutableArray array];
    
    //遍历设置每个item的布局属性
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [attributes addObject:attribute];
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    attribute.size = [self.delegate myPickLayoutSizeForItemAtIndexPath:indexPath];
    attribute.center = self.collectionView.center;
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    
    //这个是3D滚轮的半径
    CGFloat radius = 50/tanf(M_PI*2/itemCount/2);
    
    //获取当前的偏移量
    float offset = self.collectionView.contentOffset.y;
    //在角度设置上，添加一个偏移角度
    float angleOffset = offset/self.collectionView.frame.size.height;
    CGFloat angle = (float)(indexPath.item+angleOffset)/itemCount*M_PI*2;
    
    //CATransform3DIdentity创建空得矩阵
    CATransform3D tran3D = CATransform3DIdentity;
    //这个值设置的是透视度，影响视觉离投影平面的距离
    tran3D.m34 = -1/900.0;
    //这个方法返回一个新的CATransform3D对象，在原来的基础上进行旋转效果的追加
    //第一个参数为旋转的弧度，后三个分别对应x，y，z轴，我们需要以x轴进行旋转
    tran3D = CATransform3DRotate(tran3D, angle, 1.0, 0, 0);
    
    //这个方法也返回一个transform3D对象，追加平移效果，后面三个参数，对应平移的x，y，z轴，我们沿z轴平移
    tran3D = CATransform3DTranslate(tran3D, 0, 0, radius);
    
    attribute.transform3D = tran3D;
    attribute.center = CGPointMake(self.collectionView.frame.size.width/2, self.collectionView.frame.size.height/2+self.collectionView.contentOffset.y);

    return attribute;
}

@end
