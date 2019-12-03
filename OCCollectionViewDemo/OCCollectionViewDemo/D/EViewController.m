//
//  EViewController.m
//  OCCollectionViewDemo
//
//  Created by ZZ on 2019/11/26.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "EViewController.h"
#import "AvQRCodeViewController.h"

@interface EViewController ()

@end

@implementation EViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}
- (void)initView {
    self.navigationItem.title = @"E";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"navGradient"]]; //这里的timg就是那张叶子图
    self.navigationController.navigationBar.layer.masksToBounds = YES;
    
    
    //导航栏背景图片
    UIImage *image = [UIImage imageNamed:@"viewBg"];
//    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 50, 300) resizingMode:(UIImageResizingModeStretch)];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    return;

    //返回按钮image
    self.navigationController.navigationBar.backIndicatorImage = [[UIImage imageNamed:@"back2"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [[UIImage imageNamed:@"back2"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    
    //设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor cyanColor]}];

    //导航栏背景色
    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];

    //系统的左右rightBarButtonItem的颜色
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
        
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回dd";
    self.navigationItem.backBarButtonItem = backItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"左边" style:(UIBarButtonItemStylePlain) target:nil action:nil];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"右边" style:(UIBarButtonItemStylePlain) target:nil action:nil];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.leftItemsSupplementBackButton = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor purpleColor]}];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //导航栏背景图片
    UIImage *image = [UIImage imageNamed:@"navBg"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:(UIImageResizingModeStretch)];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        
    
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]]; //去除导航栏自带阴影
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = [UIColor blackColor]; //这个随便设置什么颜色，切记不可设置为clearColor
//    view.frame = CGRectMake(0, -1, [UIScreen mainScreen].bounds.size.width, 1);
//    view.layer.shadowOpacity = 0.7; //不透明度
//    view.layer.shadowOffset = CGSizeMake(0, 3); //偏移距离
//    view.layer.shadowRadius = 5; //阴影半径
//    [self.view addSubview: view];
    
    [self.navigationController pushViewController:[AvQRCodeViewController new] animated:YES];

}



@end
