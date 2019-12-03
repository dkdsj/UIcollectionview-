//
//  Header.h
//  OCCollectionViewDemo
//
//  Created by ZZ on 2019/11/26.
//  Copyright © 2019 ZZ. All rights reserved.
//

#ifndef Header_h
#define Header_h

#import "Masonry.h"

#pragma mark - color

//RGB
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b) RGBA(r, g, b, 1.0f)

//颜色
#define kColorWithHex(s)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]
#define kColorWithHexA(s,a)  [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:a]

//随机颜色
#define kColorRandom RGBA(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))


//
// MARK: -  <#name#>
//

#define kScreenWidth UIScreen.mainScreen.bounds.size.width
#define kScreenHeight UIScreen.mainScreen.bounds.size.height

#define wCv UIScreen.mainScreen.bounds.size.width
#define hCv 200

#define kSafeBottom34 (kIsPhoneX ? 34.f : 0.f)
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kTabBarHeight    self.tabBarController.tabBar.frame.size.height
#define kNavBarHeight    self.navigationController.navigationBar.frame.size.height

// 判断是否为iPhone X 系列  这样写消除了在Xcode10上的警告。
#define kIsPhoneX \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#endif /* Header_h */
