//
//  YViewController.m
//  OCCollectionViewDemo
//
//  Created by ZZ on 2019/12/2.
//  Copyright © 2019 ZZ. All rights reserved.
//

#import "YViewController.h"
#include <CoreLocation/CoreLocation.h>

@interface YViewController ()

@end

@implementation YViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str=@"哈哈呵呵嘿嘿吼吼";
    NSCharacterSet *cs= [NSCharacterSet characterSetWithCharactersInString:@"哈吼"];
    NSString *strResult = [str stringByTrimmingCharactersInSet:cs];
    NSLog(@"%@",strResult);//呵呵嘿嘿
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //青海省玉树藏族自治州治多县索加乡
    NSString *latString = @"-34.0178524497";
    NSString *lonString = @"93.3383025100";
    NSString *rst =[self formatDegreeMinuteSecondWithLatitude:latString longitude:lonString];
    
    //result 1 - (34°01‘04“N, 93°20‘17“E)
    NSLog(@"result 1 - %@", rst);
    
    NSString *dLat = @"-34°01‘04“N";
    NSString *dLon = @"93°20‘17“E";
    CLLocationCoordinate2D coor = [self getCoordinate2DWithLatitude:dLat longitude:dLon];
    
    //result 2 - (34.017776, 93.338058)
    NSLog(@"result 2 - (%f, %f)", coor.latitude, coor.longitude);
}


#pragma mark - ================= 度分秒格式转换成经纬度 ======================

/**
 度分秒格式转换成经纬度
(34°01‘04“N, 93°20‘17“E) -> (34.0178524497, 93.3383025100)
*/
- (CLLocationCoordinate2D)getCoordinate2DWithLatitude:(NSString *)latitudeStr longitude:(NSString *)longitudestr {
    NSMutableString *mStr = [NSMutableString stringWithString:latitudeStr];
    NSString *tmp = [mStr stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
    float latitude = [self string2Float:tmp];
    
    mStr = [NSMutableString stringWithString:longitudestr];
    tmp = [mStr stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
    float longitude = [self string2Float:tmp];
    
    return CLLocationCoordinate2DMake(latitude, longitude);
}

/**
 34°01‘04“ -> [34,01,04,] -> [34, 01/60, 04/60/60] -> 34+01/60+04/60/60
 */
- (float)string2Float:(NSString *)string {
    NSMutableArray *dmsStrs = [NSMutableArray arrayWithArray:[string componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"°‘“"]]];
    if (dmsStrs.count>3) [dmsStrs removeLastObject];
    if (dmsStrs.count<3) return 0.0f;
    
    float degree = [dmsStrs[0] doubleValue]/1;
    float minute = [dmsStrs[1] doubleValue]/60;
    float second = [dmsStrs[2] doubleValue]/60/60;
    
    return degree+minute+second;
}

#pragma mark - ================= 经纬度转换成度分秒格式 ======================
/**
 经纬度转换成度分秒格式
(34.0178524497, 93.3383025100) -> (34°01‘04“N, 93°20‘17“E)
*/
- (NSString *)formatDegreeMinuteSecondWithLatitude:(NSString *)latitude longitude:(NSString *)longitude {

    int lan = [latitude intValue];
    int lon = [longitude intValue];
    
    //纬度 N S
    NSString *suffixLan = lan>0?@"N":@"S";
    //经度 E W
    NSString *suffixLon = lon>0?@"E":@"W";
    
    NSString *lanStr = [NSString stringWithFormat:@"%@%@", [self convert2DMSFormat:latitude], suffixLan];
    NSString *lonStr = [NSString stringWithFormat:@"%@%@", [self convert2DMSFormat:longitude], suffixLon];
    
    //(34°01‘04“N, 93°20‘17“E)
    return [NSString stringWithFormat:@"(%@, %@)", lanStr, lonStr];
}

- (NSString *)convert2DMSFormat:(NSString *)coordinateString {
    /** 将经度或纬度整数d部分提取出来 */
    int degree = [coordinateString intValue];
    int minute = 0;
    int second = 0;
    
    NSString *passStr = [NSString stringWithFormat:@"%@", coordinateString];
    passStr = [self convertStringToInt:passStr outNum:&minute];
    passStr = [self convertStringToInt:passStr outNum:&second];
    
    /** 将经度或纬度字符串合并为(xx°xx')形式 */
    NSString *string = [NSString stringWithFormat:@"%.2d°%.2d‘%.2d“", degree, minute, second];
    return string;
}

//取小数点后面的数 度->分/秒
- (NSString *)convertStringToInt:(NSString *)string outNum:(int *)num {
    NSArray *array = [string componentsSeparatedByString:@"."];
    NSString *tmpStr = [NSString stringWithFormat:@"0.%@", array.lastObject];
    
    double number = [tmpStr doubleValue] * 60.0;
    string = [NSString stringWithFormat:@"%f", number];
    
    *num = (int)number;
    
    return string;
}


@end
