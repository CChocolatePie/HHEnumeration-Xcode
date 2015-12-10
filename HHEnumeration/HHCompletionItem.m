//
//  HHCompletionItem.m
//  HHEnumeration-Xcode
//
//  Created by huaxi on 15/10/31.
//  Copyright © 2015年 huaxi. All rights reserved.
//

#import "HHCompletionItem.h"


@interface HHCompletionItem ()

@property(nonatomic, copy) NSString *disType;
@property(nonatomic, copy) NSString *disText;

@end

@implementation HHCompletionItem

- (id)initWithdisplayType:(NSString *)displayType displayText:(NSString *)displayText
{
    if (self = [super init]) {
        self.disType = displayType;
        self.disText = displayText;
    }
    return self;
}

- (void)_fillInTheRest
{
    
}
- (long long)priority
{
    return 9999;
}

- (NSString *)name
{
    return self.disText;
}
// 最终输出到当前的文本
- (NSString *)completionText
{
    return self.disText;
}
// 提示列表 属性的 数据类型
- (NSString *)displayType
{
    return self.disType;
}
// 提示 列表框 里面的显示的文本
- (NSString *)displayText
{
    return self.disText;
}

// 属性或方法是否可用   又没过期，是否显示红色的划线
- (BOOL)notRecommended
{
    return NO;
}
// 类型的图标   前面的   E  K  C  T 。。。
- (DVTSourceCodeSymbolKind *)symbolKind
{
    return nil;
}

@end
