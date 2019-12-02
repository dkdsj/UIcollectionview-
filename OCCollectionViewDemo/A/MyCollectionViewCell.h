//
//  MyCollectionViewCell.h
//  OCCollectionViewDemo
//
//  Created by ZZ on 2019/11/25.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *lbName;

- (void)configModel:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
