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

@interface HHEnumeration()

@property (nonatomic, strong) IDEIndex *index;
@property (assign, nonatomic) NSRange lastRange;
@property (strong, nonatomic) id eventMonitor;

@end

@implementation HHEnumeration

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    BOOL isXcode = bundleID && [bundleID caseInsensitiveCompare:@"com.apple.dt.Xcode"] == NSOrderedSame;
    if (isXcode) {
        [self sharedPlugin];
    }
}

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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didApplicationFinishLaunchingNotification:) name:NSApplicationDidFinishLaunchingNotification object:nil];
        
    }
    return self;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification*)noti
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(indexDidChange:) name:@"IDEIndexDidChangeNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textSelectedDidChange:) name:NSTextViewDidChangeSelectionNotification object:nil];
}

- (void)indexDidChange:(NSNotification *)noti
{
    self.index = noti.object;
    
    
}
- (void)textSelectedDidChange:(NSNotification *)noti
{
    if ([[noti object] isKindOfClass:[NSTextView class]])
    {
        NSTextView* textView = (NSTextView *)[noti object];
        
        NSArray* selectedRanges = [textView selectedRanges];
        if (selectedRanges.count > 0)
        {
            NSRange selectedRange = [[selectedRanges objectAtIndex:0] rangeValue];
            NSString *text = textView.textStorage.string;
            NSString *selectedText = [text substringWithRange:selectedRange];
            NSInteger loc = selectedRange.location;
            BOOL isOut = ((loc < self.lastRange.location) ||
                          (loc > self.lastRange.location + self.lastRange.length)) ? YES : NO;
            if (isOut) self.lastRange = NSRangeFromString(@"{0,0}");

            if ((selectedText == nil) || [selectedText isEqualToString:@""]) return;
            
            BOOL isSame = NSEqualRanges(self.lastRange, selectedRange);
            if (!isSame) {
                
                NSString *enumName = [HHEnumFormater  enumFormaterWithString:selectedText];                if (enumName) {
                    
                    NSString *enumPre = [self startFindEnum:enumName];
                    if (enumPre && self.isOC) {
                        
                    NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
                    NSString *currentText = [pasteBoard stringForType:NSPasteboardTypeString];
                    [pasteBoard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
                    [pasteBoard setString:enumName forType:NSStringPboardType];
                        
                    [HHKeyboardEvent eventWithKeyCode:kVK_ANSI_V hasCommand:YES];
                    [HHKeyboardEvent eventWithKeyCode:kVK_F19];
                    self.eventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSKeyDownMask handler:^NSEvent *(NSEvent * incomingEvent) {
                        if ([incomingEvent type] == NSKeyDown && [incomingEvent keyCode] == kVK_F19) {
                        [NSEvent removeMonitor:self.eventMonitor];
                        self.eventMonitor = nil;
                        [pasteBoard setString:currentText forType:NSStringPboardType];
                            return nil;
                        }else{
                            return incomingEvent;
                        }
                    }];
                        [HHKeyboardEvent eventWithKeyCode:kVK_Escape];
                    }
                    enumPre = nil;
                }
                self.lastRange = selectedRange;
            }
        }
    }
}

- (NSString *)startFindEnum:(NSString *)enumName
{
    IDEIndex *index = self.index;
    NSMutableArray *enumMembers = [NSMutableArray array];
    if(index == nil) return nil;
    IDEIndexCollection *collection = [index allSymbolsMatchingName:enumName kind:nil];
    for(IDEIndexSymbol *symbol in collection.allObjects)
    {
        DVTSourceCodeSymbolKind *symbolKind = symbol.symbolKind;
        BOOL isSymbolKindEnum = NO;
        for(DVTSourceCodeSymbolKind  *conformingSymbol in symbolKind.allConformingSymbolKinds) {
            isSymbolKindEnum = [conformingSymbol.identifier isEqualToString:@"Xcode.SourceCodeSymbolKind.Enum"];
        }
        if (!isSymbolKindEnum) return nil;
        
        if(symbolKind.isContainer) {
            for(IDEIndexSymbol *child in [((IDEIndexContainerSymbol*)symbol).children allObjects])
            {
                [enumMembers addObject:child.displayName];
            }
            return [self prefixWithArray:enumMembers mayHavePrefix:enumName];
        }
        break;
    }
    return nil;
}


- (NSString *)prefixWithArray:(NSArray *)array mayHavePrefix:(NSString *)enumName;
{
    NSString *preString = [[NSString alloc] init];
    BOOL canReturn = YES;
    for (NSString *pre in array) {
        if (![pre hasPrefix:enumName]) {
            preString = [enumName substringToIndex:enumName.length - 1];
            canReturn = NO;
            break;
        }
    }
    return canReturn ? enumName : [self prefixWithArray:array mayHavePrefix:preString];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
