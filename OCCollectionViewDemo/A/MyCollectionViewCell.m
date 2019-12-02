//
//  MyCollectionViewCell.m
//  OCCollectionViewDemo
//
//  Created by ZZ on 2019/11/25.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "MyCollectionViewCell.h"
#import "Header.h"

@implementation MyCollectionViewCell
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
    self.contentView.backgroundColor = kColorRandom;

}

- (void)configModel:(NSString *)text {
    self.lbName.text = text;
}

- (UILabel *)lbName {
    if (!_lbName) {
        _lbName = [UILabel new];
        _lbName.textAlignment = 1;
        [self.contentView addSubview:_lbName];
    }
    return _lbName;
}
@end
