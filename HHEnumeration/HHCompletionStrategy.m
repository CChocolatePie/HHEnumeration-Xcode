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


extern NSArray *currentItems;
extern BOOL shouldCall;
extern BOOL isOC;


@implementation HHCompletionStrategy

- (id)completionItemsForDocumentLocation:(DVTTextDocumentLocation *)arg1 context:(NSDictionary *)arg2 highlyLikelyCompletionItems:(id *)arg3 areDefinitive:(char *)arg4
{
    
    // 激活插件
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [HHEnumeration sharedPlugin];
    });
    
    id language = [arg2 objectForKey:@"DVTTextCompletionContextSourceCodeLanguage"];
    isOC = [[language identifier] isEqualToString:@"Xcode.SourceCodeLanguage.Objective-C"];
    
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
