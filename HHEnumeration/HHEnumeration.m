//
//  HHEnumeration.m
//  HHEnumeration
//
//  Created by huaxi on 15/10/10.
//  Copyright © 2015年 huaxi. All rights reserved.
//

#import "HHEnumeration.h"
#import "HHEnumFormater.h"
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
        self.enumMembers = [NSMutableArray array];
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
                
                NSString *enumName = [HHEnumFormater enumFormaterWithString:selectedText];
                if (enumName == nil) {
                    return;
                }

                NSArray *tempArray = [self tryFindEnum:enumName];
                if (tempArray.count >= 1) {
                    
                    [HHKeyboardEvent eventWithKeyCode:kVK_Delete];
                    shouldCall = YES;
                    currentItems = [NSMutableArray arrayWithArray:tempArray];
                    tempArray = nil;
                    [HHKeyboardEvent eventWithKeyCode:kVK_Escape];
                    
                }
                
            }else {

                if (isAccepted) {
                    isAccepted = NO;
                    NSString *displayType = [NSString stringWithString:completionItem.displayType];
                    NSString *displayText = [NSString stringWithString:completionItem.displayText];
                    
                    if ([displayType containsString:@"*"]) {
                        return;
                    }
                    
                    NSArray *tempArray = [self tryFindEnum:displayType];
                    if (tempArray.count >= 1) {
                        
                        self.enumMembers = tempArray;
                        self.matchString1 = [NSString stringWithFormat:@".%@ = ",displayText];
                        self.matchString2 = [NSString stringWithFormat:@".%@ == ",displayText];
                        
                    }
                }
                
                if((self.matchString1 != nil) && (self.matchString1.length > 0)){
                    
                    NSUInteger length = self.matchString2.length;
                    if (storageText.length < length) {
                        return;
                    }
                    NSRange rang = NSMakeRange(selectedRange.location - length, length);
                    NSString *subStr = [storageText substringWithRange:rang];
                    
                    if ([subStr containsString:self.matchString1] ||
                        [subStr isEqualToString:self.matchString2] ) {
                        
                        self.matchString1 = nil;
                        self.matchString2 = nil;
                        shouldCall = YES;
                        currentItems = [NSMutableArray arrayWithArray:self.enumMembers];
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
