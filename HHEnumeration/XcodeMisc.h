//
//  XcodeMisc.h
//  HHEnumeration
//
//  Created by huaxi on 15/10/10.
//  Copyright © 2015年 huaxi. All rights reserved.
//

// xcode 头文件定义

#import <Cocoa/Cocoa.h>

@class NSArray, NSString, DVTViewController, DVTTextCompletionListWindowController;

@class DVTCompletingTextView;


@interface NSObject ()
- (id)filesContaining:(id)arg1 anchorStart:(BOOL)arg2 anchorEnd:(BOOL)arg3 subsequence:(BOOL)arg4 ignoreCase:(BOOL)arg5 cancelWhen:(id)arg6;
- (id)fileDataTypePresumed;
- (BOOL)conformsTo:(id)arg1;
- (BOOL)conformsToAnyIdentifierInSet:(id)arg1;
- (id)databaseQueryProvider;
- (id)codeCompletionsAtLocation:(id)arg1 withCurrentFileContentDictionary:(id)arg2 completionContext:(id *)arg3 sortedUsingBlock:(id)arg4;
- (NSRange)characterRange; //DVTTextDocumentLocation
- (NSRange)lineRange; //DVTTextDocumentLocation

- (id)symbolNameAtCharacterIndex:(unsigned long long)arg1 nameRanges:(id *)arg2; //DVTSourceTextStorage
- (id)sourceModelItemAtCharacterIndex:(unsigned long long)arg1; //DVTSourceTextStorage in Xcode 5, DVTSourceLanguageSourceModelService protocol in Xcode 5.1
- (id)sourceModel; //DVTSourceTextStorage

@property(readonly) id sourceModelService; // DVTSourceTextStorage

- (id)stringConstantAtLocation:(unsigned long long)arg1; //DVTSourceModel

- (id)previousItem; //DVTSourceModelItem

- (id)_listWindowController; //DVTTextCompletionSession
@end

@interface IDEIndex : NSObject

- (id)allSymbolsMatchingName:(id)arg1 kind:(id)arg2;

- (void)beginTextIndexing;

@end

@interface IDEWorkspace : NSObject


@end



@interface DVTCompletingTextView : NSTextView

- (BOOL)shouldAutoCompleteAtLocation:(unsigned long long)arg1;

@end

@interface DVTSourceTextView : DVTCompletingTextView

- (struct _NSRange)_indentInsertedTextIfNecessaryAtRange:(struct _NSRange)arg1;

@end



@interface DVTSourceCodeSymbolKind : NSObject <NSCopying>

@property(readonly) NSString *identifier;
@property(readonly, getter=isContainer) BOOL container;
@property(readonly) NSArray *allConformingSymbolKinds;

@end

@interface IDEIndexSymbol : NSObject

@property(readonly, nonatomic) DVTSourceCodeSymbolKind *symbolKind;

- (id)displayName;

@end


@interface IDEIndexContainerSymbol : IDEIndexSymbol

- (id)children;

@end


@interface IDEIndexCollection : NSObject <NSFastEnumeration>

- (id)allObjects;

@end


@interface DVTTextCompletionSession : NSObject

@property(readonly) unsigned long long wordStartLocation;
@property(readonly) DVTTextCompletionListWindowController *listWindowController;
@property(readonly) DVTCompletingTextView *textView;

- (BOOL)insertCurrentCompletion;

@end

@interface DVTTextCompletionController : NSObject

- (BOOL)acceptCurrentCompletion;
- (BOOL)_showCompletionsAtCursorLocationExplicitly:(BOOL)arg1;

@end


@interface IDEIndexCompletionItem : NSObject
{
    void *_completionResult;
    NSString *_displayText;
    NSString *_displayType;
    NSString *_completionText;
    DVTSourceCodeSymbolKind *_symbolKind;
    long long _priority;
    NSString *_name;
}
@property long long priority;
@property(readonly) NSString *name; 
@property(readonly) BOOL notRecommended;
@property(readonly) DVTSourceCodeSymbolKind *symbolKind;
@property(readonly) NSAttributedString *descriptionText;
@property(readonly) NSString *completionText;
@property(readonly) NSString *displayType;
@property(readonly) NSString *displayText;
@end

@interface DVTTextCompletionListWindowController : NSWindowController
- (id)_selectedCompletionItem;
@end


@interface DVTTextCompletionStrategy : NSObject

- (id)completionItemsForDocumentLocation:(id)arg1 context:(id)arg2 highlyLikelyCompletionItems:(id *)arg3 areDefinitive:(char *)arg4;
- (void)prepareForDocumentLocation:(id)arg1 context:(id)arg2;

@end

@interface IDEIndexCompletionStrategy : DVTTextCompletionStrategy

- (id)completionItemsForDocumentLocation:(id)arg1 context:(id)arg2 highlyLikelyCompletionItems:(id *)arg3 areDefinitive:(char *)arg4;



@end



