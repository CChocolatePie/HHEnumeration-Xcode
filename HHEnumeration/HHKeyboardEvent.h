//
//  HHKeyboardEvent.h
//  HHEnumeration
//
//  Created by huaxi on 15/10/11.
//  Copyright © 2015年 huaxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

@interface HHKeyboardEvent : NSObject

+ (void)eventWithKeyCode:(NSInteger)keyCode hasCommand:(BOOL) hasCommand;
+ (void)eventWithKeyCode:(NSInteger)keyCode;

@end
