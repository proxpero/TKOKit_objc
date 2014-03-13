//
//  TKODocument.m
//  TKOProblemTemplateClassDemo
//
//  Created by Todd Olsen on 3/5/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKODocument.h"
#import "NSView+TKOKit.h"
#import "TKOTextSystem.h"
#import "TKODisclosingView.h"
#import "NSScrollView+TKOKit.h"
#import "TKOProblemTemplatePicker.h"

#import "TKOTemplatePicker.h"
#import "TKOAlignmentInspectorViewController.h"
#import "TKOFontInspectorViewController.h"

@interface TKODocument () <NSTextViewDelegate, TKOTemplatePickerDataSource>

@property (strong, nonatomic) TKOTextStorage * textStorage;
@property (weak) IBOutlet NSScrollView *textScrollView;

@property (weak) IBOutlet NSStackView *stackView;
@property (strong, nonatomic) TKODisclosingView *disclosingView;

@property (strong) IBOutlet NSView *testView;
@property (strong) IBOutlet NSButton *addButton;
@property (strong) IBOutlet NSScrollView *scrollView;
@property (strong) IBOutlet NSView *testView2;

@property (strong, nonatomic) TKOProblemTemplatePicker * templatePicker;
@property (strong, nonatomic) TKOAlignmentInspectorViewController * alignmentVC;
@property (strong, nonatomic) TKOFontInspectorViewController * fontVC;

@end

@implementation TKODocument

- (void)setupTextSystem
{
    NSLayoutManager * layoutManager = [[NSLayoutManager alloc] init];
    [self.textStorage addLayoutManager:layoutManager];
    
    TKOTextContainer * textContainer = [[TKOTextContainer alloc] init];
    [layoutManager addTextContainer:textContainer];
    TKOTextView * textView = [[TKOTextView alloc] initWithFrame:NSZeroRect
                                                  textContainer:textContainer];
    
    [textView setTextContainerInset:NSMakeSize(20, 20)];
//    [[NSNotificationCenter defaultCenter] addObserver:self.listInspector
//                                             selector:@selector(updateListAttributes:)
//                                                 name:NSTextViewDidChangeSelectionNotification
//                                               object:textView];
    [self.textScrollView setDocumentView:textView];
//    [self.listInspector setTextView:textView];
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
    
    TKOTemplatePicker * picker = [[TKOTemplatePicker alloc] initWithTitle:@"Template"];
//    TKODisclosingView * pickerDisclosingView = [NSView viewWithClass:[TKODisclosingView class]];
//    [pickerDisclosingView setTrimsTopContentHeight:NO];
//    [pickerDisclosingView setTitle:@"Templates"];
//    [pickerDisclosingView setContentView:picker];

    [self.stackView addView:picker
                  inGravity:NSStackViewGravityTop];
    [self.stackView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[picker]|"
                                             options:0
                                             metrics:nil
                                               views:@{@"picker": picker}]
     ];
    
    [picker setDataSource:self];
    
    self.alignmentVC = [[TKOAlignmentInspectorViewController alloc] init];
    [self.stackView addView:self.alignmentVC.view
                  inGravity:NSStackViewGravityTop];
    
    self.fontVC = [[TKOFontInspectorViewController alloc] init];
    [self.stackView addView:self.fontVC.view
                  inGravity:NSStackViewGravityTop];
    
    [self setupTextSystem];
}

- (NSUInteger)templatePickerNumberOfItems:(TKOTemplatePicker *)templatePicker
{
    return 5;
}

- (id)templatePicker:(TKOTemplatePicker *)templatePicker
         itemAtIndex:(NSUInteger)index
{
    return [NSString stringWithFormat:@"Template %lu", index];
}

- (NSString *)templatePicker:(TKOTemplatePicker *)templatePicker
                titleForItem:(id)item
{
    return [NSString stringWithFormat:@"%@ Title", item];
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
