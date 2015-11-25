//
//  HHCompletionStrategy.m
//  HHEnumeration-Xcode
//
//  Created by huaxi on 15/10/30.
//  Copyright © 2015年 huaxi. All rights reserved.
//
#import "HHCompletionStrategy.h"
#import "XcodeMisc.h"
#import "HHEnumeration.h"


extern NSMutableArray *currentItems;
extern BOOL shouldCall;

@implementation HHCompletionStrategy

- (id)completionItemsForDocumentLocation:(DVTTextDocumentLocation *)arg1 context:(NSDictionary *)arg2 highlyLikelyCompletionItems:(id *)arg3 areDefinitive:(char *)arg4
{
//    id language = [arg2 objectForKey:@"DVTTextCompletionContextSourceCodeLanguage"];
//    BOOL isOC = [[language identifier] isEqualToString:@"Xcode.SourceCodeLanguage.Objective-C"];
    // 激活插件
    [HHEnumeration sharedPlugin];

    NSMutableArray *completions = nil;
    if (shouldCall)
    {
        completions = [NSMutableArray arrayWithArray:currentItems];
        *arg3 = completions;
        *arg4 = 1;
        shouldCall = NO;
        currentItems = nil;
    }

    return completions;

}
@end
