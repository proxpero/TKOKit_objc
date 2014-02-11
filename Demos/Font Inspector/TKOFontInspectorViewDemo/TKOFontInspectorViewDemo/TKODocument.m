//
//  TKODocument.m
//  TKOFontInspectorViewDemo
//
//  Created by Todd Olsen on 2/8/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKODocument.h"
#import "TKOTextSystem.h"
#import "TKOFontInspectorViewController.h"

@interface TKODocument () <NSTextViewDelegate>

@property (strong, nonatomic) TKOTextStorage * textStorage;
@property (weak) IBOutlet NSScrollView *textScrollView;
@property (weak) IBOutlet NSScrollView *inspectorScrollView;

@property (strong) TKOFontInspectorViewController * fontInspector;

@end

@implementation TKODocument

//- (void)textViewDidChangeTypingAttributes:(NSNotification *)notification
//{
//    [self.fontInspector updateFonts];
//}
//
//- (void)textViewDidChangeSelection:(NSNotification *)notification
//{
//    [self.fontInspector updateFonts];
//}

- (void)setupTextSystem
{
    NSLayoutManager * layoutManager = [[NSLayoutManager alloc] init];
    [self.textStorage addLayoutManager:layoutManager];
    
    TKOTextContainer * textContainer = [[TKOTextContainer alloc] init];
    [layoutManager addTextContainer:textContainer];
    TKOTextView * textView = [[TKOTextView alloc] initWithFrame:NSZeroRect
                                                  textContainer:textContainer];
    
    [textView setTextContainerInset:NSMakeSize(20, 20)];
    [[NSNotificationCenter defaultCenter] addObserver:self.fontInspector
                                             selector:@selector(textViewDidChangeFont:)
                                                 name:TKOTextViewDidChangeFontNotification
                                               object:textView];
    [self.textScrollView setDocumentView:textView];
}

- (void)setupFontInspector
{
    if (self.fontInspector)
        return;
    
    self.fontInspector = [[TKOFontInspectorViewController alloc] init];
    [self.inspectorScrollView setDocumentView:self.fontInspector.view];
    
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
    [self setupFontInspector];
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
