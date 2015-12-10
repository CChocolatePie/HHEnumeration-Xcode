//
//  DVTTextCompletionController+HHEnumeration.m
//  HHEnumeration-Xcode
//
//  Created by huaxi on 15/12/10.
//  Copyright © 2015年 huaxi. All rights reserved.
//

#import "DVTTextCompletionController+HHEnumeration.h"
#import "MethodSwizzle.h"
extern BOOL isAccepted;

@implementation DVTTextCompletionController (HHEnumeration)
+ (void)load
{
    MethodSwizzle(self, @selector(acceptCurrentCompletion),
                  @selector(hh_acceptCurrentCompletion));
}
- (BOOL)hh_acceptCurrentCompletion
{
    isAccepted = [self hh_acceptCurrentCompletion];
    return isAccepted;
}
@end
