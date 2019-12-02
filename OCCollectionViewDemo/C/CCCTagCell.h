//
//  CCCTagCell.h
//  OCCollectionViewDemo
//
//  Created by ZZ on 2019/11/28.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCCTagCell : UICollectionViewCell
@property (nonatomic, strong) NSString *nameStr;

@property (nonatomic, strong) UILabel *lbName;
@end

NS_ASSUME_NONNULL_END
