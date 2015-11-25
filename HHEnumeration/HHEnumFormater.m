//
//  HHEnumFormater.m
//  HHEnumerater
//
//  Created by huaxi on 15/10/8.
//  Copyright © 2015年 huaxi. All rights reserved.
//



#import "HHEnumeration.h"
#import "HHEnumFormater.h"

@implementation HHEnumFormater
+ (NSString *)enumFormaterWithString:(NSString *)str;
{

    if ([str isEqualToString:@"<#expression#>"]) return nil;
    if ([str isEqualToString:@"<#constant#>"]) return nil;
    if ([str isEqualToString:@"<#statements#>"]) return nil;
    NSString *subStr;
    NSString *enumName;
    
    if ([str hasPrefix:@"<#("] &&
        [str hasSuffix:@")#>"])
    {

        if ( [str containsString:@"*"]) return nil;
        if ( [str containsString:@" "]) return nil;
        if ( [str containsString:@"id"] && (str.length == 8)) return  nil;
        if ( [str containsString:@"id<"]) return nil;
        
        subStr = [str substringFromIndex:3];
        enumName = [subStr substringToIndex:subStr.length - 3];
        return enumName;
    }
    return nil;
}
@end
