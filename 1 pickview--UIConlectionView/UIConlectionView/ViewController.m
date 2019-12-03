//
//  ViewController.m
//  UIConlectionView
//
//  Created by jaki on 15/10/27.
//  Copyright © 2015年 jaki. All rights reserved.
//

#import "ViewController.h"
#import "MyLayout.h"
#import "CollectionViewCell.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MyLayout * layout = [[MyLayout alloc]init];
     UICollectionView * collect  = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 320, 400) collectionViewLayout:layout];
    collect.delegate=self;
    collect.dataSource=self;
    collect.contentOffset = CGPointMake(0, 400);
    [collect registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
  
    [self.view addSubview:collect];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    
    cell.text = [NSString stringWithFormat:@"我是第%ld行",(long)indexPath.item];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    NSLog(@"%zd-%@", indexPath.item, cell.text);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<200) {
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y+10*400);
    }else if(scrollView.contentOffset.y>11*400){
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y-10*400);
    }
}
@end
