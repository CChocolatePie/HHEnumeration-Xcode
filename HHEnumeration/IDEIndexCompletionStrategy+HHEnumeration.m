//
//  IDEIndexCompletionStrategy+HHEnumeration.m
//  HHEnumeration
//
//  Created by huaxi on 15/10/10.
//  Copyright © 2015年 huaxi. All rights reserved.
//

#import "IDEIndexCompletionStrategy+HHEnumeration.h"
#import "MethodSwizzle.h"
#import "HHEnumeration.h"

@implementation IDEIndexCompletionStrategy (HHEnumeration)

+ (void)load
{
    MethodSwizzle(self, @selector(completionItemsForDocumentLocation:context:
                                  highlyLikelyCompletionItems:areDefinitive:),
                        @selector(hh_completionItemsForDocumentLocation:context:
                                  highlyLikelyCompletionItems:areDefinitive:));
}


- (id)hh_completionItemsForDocumentLocation:(id)arg1 context:(id)arg2 highlyLikelyCompletionItems:(id *)arg3 areDefinitive:(char *)arg4;
{

    id language = [arg2 objectForKey:@"DVTTextCompletionContextSourceCodeLanguage"];
    BOOL isOC = [[language identifier] isEqualToString:@"Xcode.SourceCodeLanguage.Objective-C"];
    [HHEnumeration sharedPlugin].isOC = isOC;
    return [self hh_completionItemsForDocumentLocation:arg1 context:arg2 highlyLikelyCompletionItems:arg3 areDefinitive:arg4];
}

@end
