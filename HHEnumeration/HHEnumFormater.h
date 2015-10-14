//
//  HHEnumFormater.h
//  HHEnumerater
//
//  Created by huaxi on 15/10/8.
//  Copyright © 2015年 huaxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHEnumFormater : NSString

/** 当不是 类似枚举 结构是 返回空 ， 类似枚举类型时 返回 名字*/
+ (NSString *)enumFormaterWithString:(NSString *)str;
@end
