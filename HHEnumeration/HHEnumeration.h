//
//  HHEnumeration.h
//  HHEnumeration
//
//  Created by huaxi on 15/10/10.
//  Copyright © 2015年 huaxi. All rights reserved.
//

#import <AppKit/AppKit.h>
@class IDEIndex;
@class HHEnumeration;



@interface HHEnumeration : NSObject

@property (nonatomic, strong, readonly) IDEIndex *index;
@property (assign, nonatomic) BOOL isOC;

//@property (assign, nonatomic) BOOL shouldCall;

+ (instancetype)sharedPlugin;

@end