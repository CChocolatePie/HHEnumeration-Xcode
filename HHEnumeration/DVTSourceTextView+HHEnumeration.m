//
//  DVTSourceTextView+HHEnumeration.m
//  HHEnumeration-Xcode
//
//  Created by huaxi on 15/10/31.
//  Copyright © 2015年 huaxi. All rights reserved.
//

#import "DVTSourceTextView+HHEnumeration.h"
#import "MethodSwizzle.h"
#import "HHEnumeration.h"


extern BOOL shouldCall;

@implementation DVTSourceTextView (HHEnumeration)

+ (void)load
{
    MethodSwizzle(self,@selector(shouldAutoCompleteAtLocation:),
                       @selector(hh_shouldAutoCompleteAtLocation:));
}

- (BOOL)hh_shouldAutoCompleteAtLocation:(unsigned long long)arg1
{
    BOOL xc_shouldAutoCompleteAtLocation = [self hh_shouldAutoCompleteAtLocation:arg1];
    
    NSLog(@"xitong %d  --- shouldCall %d",xc_shouldAutoCompleteAtLocation,shouldCall);
    @try {
        if (!xc_shouldAutoCompleteAtLocation) {
            xc_shouldAutoCompleteAtLocation = shouldCall;
        }
    }
    @catch (NSException *exception) {
        
    }

    return xc_shouldAutoCompleteAtLocation;
}
@end
