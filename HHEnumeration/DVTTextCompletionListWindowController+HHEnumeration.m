//
//  DVTTextCompletionListWindowController+HHEnumeration.m
//  HHEnumeration-Xcode
//
//  Created by huaxi on 15/12/10.
//  Copyright © 2015年 huaxi. All rights reserved.
//

#import "DVTTextCompletionListWindowController+HHEnumeration.h"
#import "MethodSwizzle.h"

extern IDEIndexCompletionItem *completionItem;

@implementation DVTTextCompletionListWindowController (HHEnumeration)

+ (void)load
{
    MethodSwizzle(self, @selector(_selectedCompletionItem),
                  @selector(hh_selectedCompletionItem));
}

- (id)hh_selectedCompletionItem
{
    completionItem = [self hh_selectedCompletionItem];
    return completionItem;
}

@end
