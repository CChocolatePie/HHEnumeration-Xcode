//
//  HHEnumeration.m
//  HHEnumeration
//
//  Created by huaxi on 15/10/10.
//  Copyright © 2015年 huaxi. All rights reserved.
//

#import "HHEnumeration.h"
#import "XcodeMisc.h"
#import "HHKeyboardEvent.h"
#import "HHCompletionItem.h"


NSArray *currentItems;

BOOL shouldCall;
BOOL isAccepted;
IDEIndexCompletionItem *completionItem;
BOOL isOC;


BOOL _isFirstNoti;

@interface HHEnumeration()

@property (nonatomic, strong) IDEIndex *index;
@property (strong, nonatomic) NSArray *enumMembers;
@property (copy, nonatomic) NSString *matchString1;
@property (copy, nonatomic) NSString *matchString2;
@property (assign, nonatomic) NSRange lastRange;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation HHEnumeration


+ (instancetype)sharedPlugin
{
    static dispatch_once_t onceToken;
    static id sharedPlugin;
    dispatch_once(&onceToken, ^{
        sharedPlugin = [[self alloc] init];
    });
    return sharedPlugin;
}

- (id)init
{
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(indexDidChange:) name:@"IDEIndexDidChangeNotification" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textSelectedDidChange:) name:NSTextViewDidChangeSelectionNotification object:nil];
        
        _isFirstNoti = YES;
        shouldCall = NO;
        isAccepted = NO;
        _enumMembers = [NSMutableArray array];
        isOC = NO;
        
    }
    return self;
}

- (void)indexDidChange:(NSNotification *)noti
{
    self.index = noti.object;
}

- (void)textSelectedDidChange:(NSNotification *)noti
{
    if (!isOC) {
        return;
    }
    
    if ([[noti object] isKindOfClass:[NSTextView class]])
    {

        // 每个通知会收到两次  过滤掉 第二次
        if (!_isFirstNoti) {
            _isFirstNoti = YES;
            return;
        }
        _isFirstNoti = NO;
    
        NSTextView* textView = (NSTextView *)[noti object];
        
        NSArray* selectedRanges = [textView selectedRanges];
        if (selectedRanges.count > 0)
        {
            NSRange selectedRange = [[selectedRanges objectAtIndex:0] rangeValue];
            NSString *storageText = textView.textStorage.string;
            NSString *selectedText = [storageText substringWithRange:selectedRange];
            
            if (![selectedText isEqualToString:@""]){
                
                NSString *enumName = [self enumNameWithString:selectedText];
                if (enumName == nil) {
                    return;
                }
                
                NSArray *tempArray = [self tryFindEnum:enumName];
                
                if (tempArray.count >= 1) {
                    
                    // 当撤销时 连续两次range 一致  不需 进行 枚举成员提示
                    if (NSEqualRanges(_lastRange, selectedRange)) {
                        
                        // 设置1秒后 清空 lastRange, 解决 撤销crash bug
                        [_timer invalidate];
                        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(clearRange) userInfo:nil repeats:NO];
                        return;
                        
                    }
                    
                    [HHKeyboardEvent eventWithKeyCode:kVK_Delete];
                    shouldCall = YES;
                    currentItems = [NSMutableArray arrayWithArray:tempArray];
                    tempArray = nil;
                    [HHKeyboardEvent eventWithKeyCode:kVK_Escape];
                 
                    _lastRange = selectedRange;
                    
                }
                
            }else {

                if (isAccepted) {
                    isAccepted = NO;
                    
                    if (!completionItem.displayType) {
                        return;
                    }
                    
                    NSString *displayType = nil;
                    
                    NSRange range = [completionItem.displayType rangeOfString:@"enum "];
                    if (range.location != NSNotFound) {
                        displayType = [completionItem.displayType substringFromIndex:(range.location + range.length)];
                    } else {
                        displayType = completionItem.displayType;
                    }
                    
                    NSString *displayText = completionItem.displayText;
                    
                    if ([displayType containsString:@"*"]) {
                        return;
                    }
                    
                    NSArray *tempArray = [self tryFindEnum:displayType];
                    if (tempArray.count >= 1) {
                        
                        _enumMembers = tempArray;
                        // 点语法 或 枚举变量  赋值 时
                        _matchString1 = [NSString stringWithFormat:@"%@ = ",displayText];
                        // 点语法 或 枚举变量  判断枚举类型 时
                        _matchString2 = [NSString stringWithFormat:@"%@ == ",displayText];
                        
                        
                    }
                }
                
                if((_matchString1 != nil) && (_matchString1.length > 0)){
                    
                    NSUInteger length = _matchString2.length;
                    if (storageText.length < length || selectedRange.location < length) {
                        return;
                    }
                    NSRange rang = NSMakeRange(selectedRange.location - length, length);
                    NSString *subStr = [storageText substringWithRange:rang];
                    
                    if ([subStr containsString:_matchString1] ||
                        [subStr isEqualToString:_matchString2] ) {
                        
                        _matchString1 = nil;
                        _matchString2 = nil;
                        shouldCall = YES;
                        currentItems = [NSMutableArray arrayWithArray:_enumMembers];
                        [HHKeyboardEvent eventWithKeyCode:kVK_Escape];
                        
                    }

                }
            }
            
        }
    }
}

- (NSArray *)tryFindEnum:(NSString *)enumName
{
    IDEIndex *index = self.index;
    if(index == nil) return nil;
    IDEIndexCollection *collection = [index allSymbolsMatchingName:enumName kind:nil];
    for(IDEIndexSymbol *symbol in collection.allObjects)
    {
        DVTSourceCodeSymbolKind *symbolKind = symbol.symbolKind;
        BOOL isSymbolKindEnum = NO;
        for(DVTSourceCodeSymbolKind  *kind in symbolKind.allConformingSymbolKinds) {
            if ([kind.identifier isEqualToString:@"Xcode.SourceCodeSymbolKind.Enum"])
            {
                isSymbolKindEnum = YES;
            }
        }
        if (isSymbolKindEnum == NO) return nil;
        
        if(symbolKind.isContainer) {
            
            NSMutableArray *enumMembers = [NSMutableArray array];
            for(IDEIndexSymbol *child in [((IDEIndexContainerSymbol*)symbol).children allObjects])
            {
                NSString *displayType = [NSString stringWithFormat:@"enum %@",enumName];
                HHCompletionItem *item = [[HHCompletionItem alloc] initWithdisplayType:displayType displayText:child.displayName];
                [enumMembers addObject:item];
            }
            // 做下排序
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"displayText" ascending:YES];
            NSArray *descriptorArr = @[descriptor];
            return (NSArray *)[enumMembers sortedArrayUsingDescriptors:descriptorArr];
            
        }

    }
    return nil;
}
- (void)clearRange
{
    [_timer invalidate];
    shouldCall = NO;
    self.lastRange = NSMakeRange(0, 0);
}
- (NSString *)enumNameWithString:(NSString *)string
{
    
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@"((?<=<#\\()[a-zA-Z]+(?=\\)#>))|((?<=<#)[a-zA-Z]+(?=\\b))" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSRange rang = [reg rangeOfFirstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
    
    if (rang.length != 0) {
        
        return [string substringWithRange:rang];
    }
    
    return nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
