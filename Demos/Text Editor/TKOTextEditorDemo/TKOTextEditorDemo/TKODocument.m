//
//  TKODocument.m
//  TKOTextEditorDemo
//
//  Created by Todd Olsen on 2/13/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKODocument.h"
#import "TKOTextSystem.h"

#import "TKOFontInspectorViewController.h"
#import "TKOAlignmentInspectorViewController.h"
#import "TKOSpacingInspectorViewController.h"

@interface TKODocument ()

@property (strong, nonatomic) TKOTextStorage * textStorage;
@property (weak) IBOutlet NSScrollView *textScrollView;
@property (weak) IBOutlet NSScrollView *inspectorScrollView;

@property (strong, nonatomic) TKOFontInspectorViewController * fontInspector;
@property (strong, nonatomic) TKOAlignmentInspectorViewController * alignmentInspector;
@property (strong, nonatomic) TKOSpacingInspectorViewController * spacingInspector;

@end

@implementation TKODocument

- (void)setupInspectors
{
    if (!self.inspectorScrollView || (self.fontInspector && self.alignmentInspector && self.spacingInspector))
        return;
    
    self.fontInspector = [[TKOFontInspectorViewController alloc] init];
    self.alignmentInspector = [[TKOAlignmentInspectorViewController alloc] init];
    self.spacingInspector = [[TKOSpacingInspectorViewController alloc] init];
    
    NSStackView * stackView = [NSStackView stackViewWithViews:@[
                                                                self.fontInspector.view,
                                                                self.alignmentInspector.view,
                                                                self.spacingInspector.view
                                                                ]];
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    stackView.alignment = NSLayoutAttributeCenterX;
    stackView.spacing = 0; // No spacing between the disclosure views
    [stackView setHuggingPriority:NSLayoutPriorityDefaultHigh
                   forOrientation:NSLayoutConstraintOrientationHorizontal];
    [self.inspectorScrollView setDocumentView:stackView];
}

- (void)setupTextSystem
{
    if (!self.textScrollView)
        return;
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self.alignmentInspector
                                             selector:@selector(textViewDidChangeAlignment:)
                                                 name:NSTextViewDidChangeSelectionNotification
                                               object:textView];
    
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
    [self setupInspectors];
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
