//
//  HHCompletionItem.h
//  HHEnumeration-Xcode
//
//  Created by huaxi on 15/10/31.
//  Copyright © 2015年 huaxi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XcodeMisc.h"

@interface HHCompletionItem : IDEIndexCompletionItem
- (id)initWithdisplayType:(NSString *)displayType displayText:(NSString *)displayText;
@end
