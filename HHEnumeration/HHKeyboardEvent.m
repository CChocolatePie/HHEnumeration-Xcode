//
//  HHKeyboardEvent.m
//  HHEnumeration
//
//  Created by huaxi on 15/10/11.
//  Copyright © 2015年 huaxi. All rights reserved.
//

#import "HHKeyboardEvent.h"

@interface HHKeyboardEvent ()
@property (strong, nonatomic) NSDictionary *keyAndCode;
@end

@implementation HHKeyboardEvent

+ (void)eventWithKeyCode:(NSInteger)keyCode hasCommand:(BOOL)hasCommand
{
    CGEventSourceRef eSourceR = CGEventSourceCreate(kCGEventSourceStateCombinedSessionState);
    CGEventTapLocation eTapR = kCGHIDEventTap;
    NSInteger flag = hasCommand ? kCGEventFlagMaskCommand : 0;
    // 按下
    CGEventRef eventR = CGEventCreateKeyboardEvent(eSourceR, keyCode, true);
    CGEventSetFlags(eventR, flag);
    CGEventPost(eTapR, eventR);
    CFRelease(eventR);
    // 弹起/松开
    eventR = CGEventCreateKeyboardEvent(eSourceR, keyCode, false);
    CGEventSetFlags(eventR, flag);
    CGEventPost(eTapR, eventR);
    CFRelease(eventR);
    
    CFRelease(eSourceR);
    eventR = nil;
    eSourceR = nil;
}

+ (void)eventWithKeyCode:(NSInteger)keyCode
{
    [self eventWithKeyCode:keyCode hasCommand:NO];
}
@end
