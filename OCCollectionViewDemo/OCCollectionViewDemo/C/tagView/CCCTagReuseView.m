//
//  CCCTagReuseView.m
//  OCCollectionViewDemo
//
//  Created by ZZ on 2019/12/2.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "CCCTagReuseView.h"
#import "Header.h"

@interface CCCTagReuseView  ()
@property (nonatomic, strong) UILabel *lbName;
@end

@implementation CCCTagReuseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        
        [self initView];
    }
    return self;
}

- (void)initView {
    [self.lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)configTagReuseView:(NSString *)nameStr {
    self.lbName.text = nameStr;
}

#pragma mark - Getter

- (UILabel *)lbName {
    if (!_lbName) {
        _lbName = [UILabel new];
        _lbName.textAlignment = 1;
        [self addSubview:_lbName];
    }
    return _lbName;
}

@end
