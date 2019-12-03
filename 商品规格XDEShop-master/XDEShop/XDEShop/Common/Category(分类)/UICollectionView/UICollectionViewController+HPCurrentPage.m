//
//  UICollectionViewController+SCCurrentPage.m
//  SCGoJD
//
//  Created by mac on 15/9/29.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "UICollectionViewController+HPCurrentPage.h"

@implementation UICollectionViewController (HPCurrentPage)

- (NSUInteger)setCurrentPageNumberWithLastPageNumber:(NSUInteger)pageNumber
                                          totalCount:(NSUInteger)count
                                              offset:(CGFloat)offset {
    
    NSUInteger currentPageNumber = pageNumber;

    for (NSUInteger i = 0; i < count; i++) {
        if (offset == self.view.bounds.size.width * i) {
            currentPageNumber = i;
        }
    }
    
    return currentPageNumber;
}

@end
