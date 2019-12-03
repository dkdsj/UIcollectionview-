//
//  CCCTagCell.m
//  OCCollectionViewDemo
//
//  Created by ZZ on 2019/11/28.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "CCCTagCell.h"

@implementation CCCTagCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    [self.lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setNameStr:(NSString *)nameStr {
    self.lbName.text = nameStr;
}

- (UILabel *)lbName {
    if (!_lbName) {
        _lbName = [UILabel new];
        _lbName.textAlignment = 1;
        
        _lbName.textColor = [UIColor blackColor];
        _lbName.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _lbName.layer.borderWidth = 1.0;
        _lbName.layer.cornerRadius = 5.0;
        _lbName.layer.masksToBounds = YES;
        
        [self.contentView addSubview:_lbName];
    }
    return _lbName;
}

@end
