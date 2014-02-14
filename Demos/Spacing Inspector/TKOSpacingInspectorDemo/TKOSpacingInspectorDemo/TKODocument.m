//
//  TKODocument.m
//  TKOSpacingInspectorDemo
//
//  Created by Todd Olsen on 2/13/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKODocument.h"
#import "TKOTextSystem.h"
#import "TKOSpacingInspectorViewController.h"

@interface TKODocument () <NSTextViewDelegate>

@property (strong, nonatomic) TKOTextStorage * textStorage;
@property (weak) IBOutlet NSScrollView *textScrollView;
@property (weak) IBOutlet NSScrollView *spacingScrollView;

@property (strong) TKOSpacingInspectorViewController * spacingInspector;

@end

@implementation TKODocument

- (void)setupSpacingInspector
{
    if (self.spacingInspector)
        return;
    
    self.spacingInspector = [[TKOSpacingInspectorViewController alloc] init];
    [self.spacingScrollView setDocumentView:self.spacingInspector.view];
}

- (void)setupTextSystem
{
    NSLayoutManager * layoutManager = [[NSLayoutManager alloc] init];
    [self.textStorage addLayoutManager:layoutManager];
    
    TKOTextContainer * textContainer = [[TKOTextContainer alloc] init];
    [layoutManager addTextContainer:textContainer];
    TKOTextView * textView = [[TKOTextView alloc] initWithFrame:NSZeroRect
                                                  textContainer:textContainer];
    
    [textView setTextContainerInset:NSMakeSize(20, 20)];
    [[NSNotificationCenter defaultCenter] addObserver:self.spacingInspector
                                             selector:@selector(textViewDidChangeSpacing:)
                                                 name:NSTextViewDidChangeSelectionNotification
                                               object:textView];
    [self.textScrollView setDocumentView:textView];
}

- (id)init
{
    self = [super init];
    if (self) {
        _textStorage = [[TKOTextStorage alloc] init];
    }
    return self;
}

- (NSString *)windowNibName
{
    return @"TKODocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    [self setupSpacingInspector];
    [self setupTextSystem];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName
                 error:(NSError **)outError
{
    NSAttributedString * string = [self.textStorage attributedSubstringFromRange:NSMakeRange(0, self.textStorage.length)];
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:string];
    return data;
}

- (BOOL)readFromData:(NSData *)data
              ofType:(NSString *)typeName
               error:(NSError **)outError
{
    NSAttributedString * string = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (string) {
        [self.textStorage setAttributedString:string];
        return YES;
    }
    return NO;
}

@end
