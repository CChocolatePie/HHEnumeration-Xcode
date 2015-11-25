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


NSMutableArray *currentItems;
DVTSourceCodeSymbolKind *currentKind;
BOOL shouldCall;


BOOL _isFirstNoti;


@interface HHEnumeration()

@property (nonatomic, strong) IDEIndex *index;

@property (strong, nonatomic) id eventMonitor;

@end

@implementation HHEnumeration

/**
 *  @author Huaxi
 *
 *  虽说插件要写这个方法， 但是现在改为 ideplugin 后缀 后， Xcode不调用这个方法了
 *  在 HHCompletionStrategy  通过调用 sharedPlugin 激活插件
 */
//+ (void)pluginDidLoad:(NSBundle *)plugin
//{
//    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
//    BOOL isXcode = bundleID && [bundleID caseInsensitiveCompare:@"com.apple.dt.Xcode"] == NSOrderedSame;
//    if (isXcode) {
//        [self sharedPlugin];
//    }
//}

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
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(indexDidChange:) name:@"IDEIndexDidChangeNotification" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textSelectedDidChange:) name:NSTextViewDidChangeSelectionNotification object:nil];
        _isFirstNoti = YES;
    }
    return self;
}

- (void)indexDidChange:(NSNotification *)noti
{
    self.index = noti.object;
}

- (void)textSelectedDidChange:(NSNotification *)noti
{
    
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
            NSString *text = textView.textStorage.string;
            NSString *selectedText = [text substringWithRange:selectedRange];

            if ((selectedText == nil) || [selectedText isEqualToString:@""]) return;
            
            NSString *enumName = [HHEnumFormater enumFormaterWithString:selectedText];
            if (enumName == nil) {
                return;
            }

            NSMutableArray *tempArray = [self startFindEnum:enumName];
            if (tempArray.count >= 2) {
//                        [textView insertText:@"" replacementRange:selectedRange];
//                        [textView replaceCharactersInRange:selectedRange withString:@""];
                //  以上两个方式 删掉  撤销操作时 会 出现 bug
                //  UIButton buttonWithType:<#(UIButtonType)#>
                //  也是奇怪了，之前用下面这个模拟手动 delete 删掉 <#(UIButtonType)#> 时 会多删 前面的 :
                //  会变成这样   UIButton buttonWithType
                //  现在又正常了 😂
                [HHKeyboardEvent eventWithKeyCode:kVK_Delete];
                shouldCall = YES;
                currentItems = [NSMutableArray arrayWithArray:tempArray];
                tempArray = nil;
                [HHKeyboardEvent eventWithKeyCode:kVK_Escape];
                
            }
            
        }
    }
}

- (NSMutableArray *)startFindEnum:(NSString *)enumName
{
    IDEIndex *index = self.index;
    if(index == nil) return nil;
    IDEIndexCollection *collection = [index allSymbolsMatchingName:enumName kind:nil];
    for(IDEIndexSymbol *symbol in collection.allObjects)
    {
        DVTSourceCodeSymbolKind *symbolKind = symbol.symbolKind;
        BOOL isSymbolKindEnum = NO;
        for(DVTSourceCodeSymbolKind  *conformingSymbol in symbolKind.allConformingSymbolKinds) {
            if ([conformingSymbol.identifier isEqualToString:@"Xcode.SourceCodeSymbolKind.Enum"])
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
            NSLog(@"%@",enumMembers);
            return (NSMutableArray *)[enumMembers sortedArrayUsingDescriptors:descriptorArr];
        
        }
        break;
    }
    return nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
