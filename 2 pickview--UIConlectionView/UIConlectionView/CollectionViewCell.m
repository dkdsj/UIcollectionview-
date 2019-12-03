//
//  CollectionViewCell.m
//  UIConlectionView
//
//  Created by ZZ on 2019/11/26.
//  Copyright © 2019 jaki. All rights reserved.
//

#import "CollectionViewCell.h"

@interface CollectionViewCell ()
@property (nonatomic, strong) UILabel *lbName;
@end

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.lbName.font = [UIFont systemFontOfSize:18];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.lbName.frame = self.contentView.bounds;
}

- (void)setText:(NSString *)text {
    _text = text;
    _lbName.text = text;
}

- (UILabel *)lbName {
    if (!_lbName) {
        _lbName = [UILabel new];
        _lbName.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_lbName];
    }
    return _lbName;
}

@end
