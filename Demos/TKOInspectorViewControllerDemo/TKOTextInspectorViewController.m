//
//  TKOTextInspectorViewController.m
//  TKOInspectorViewControllerDemo
//
//  Created by Todd Olsen on 2/19/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOTextInspectorViewController.h"
#import "TKOTextSystem.h"

#import "TKOPopoverPickerControl.h"

#import "TKOFontInspectorViewController.h"
#import "TKOAlignmentInspectorViewController.h"
#import "TKOSpacingInspectorViewController.h"
#import "TKOListsInspectorViewController.h"


@interface TKOTextInspectorViewController ()

@property (weak) IBOutlet TKOPopoverPickerControl                   * stylePicker;
@property (strong, nonatomic) IBOutlet NSScrollView                 * inspectorScrollView;

@property (strong, nonatomic) TKOFontInspectorViewController        * fontInspector;
@property (strong, nonatomic) TKOAlignmentInspectorViewController   * alignmentInspector;
@property (strong, nonatomic) TKOSpacingInspectorViewController     * spacingInspector;
@property (strong, nonatomic) TKOListsInspectorViewController       * listInspector;

@end

@implementation TKOTextInspectorViewController

- (id)initWithTextView:(TKOTextView *)textView
{
    self = [super initWithNibName:@"TKOTextInspectorViewController"
                           bundle:nil];

    [self setTitle:@"Text"];
    
    self.fontInspector      = [[TKOFontInspectorViewController alloc] init];
    self.alignmentInspector = [[TKOAlignmentInspectorViewController alloc] init];
    self.spacingInspector   = [[TKOSpacingInspectorViewController alloc] init];
    self.listInspector      = [[TKOListsInspectorViewController alloc] init];

    _textView = textView;
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.stylePicker setTextView:self.textView];
    NSStackView * stackView = [NSStackView stackViewWithViews:@[
                                                                self.fontInspector.view,
                                                                self.alignmentInspector.view,
                                                                self.spacingInspector.view,
                                                                self.listInspector.view,
                                                                ]];
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    stackView.alignment = NSLayoutAttributeCenterX;
    stackView.spacing = 0; // No spacing between the disclosure views
    [stackView setHuggingPriority:NSLayoutPriorityDefaultHigh
                   forOrientation:NSLayoutConstraintOrientationHorizontal];
    [self.inspectorScrollView setDocumentView:stackView];
    [self updateTextViewForComponents];
}

- (void)setTextView:(TKOTextView *)textView
{
    if (_textView == textView)
        return;
    _textView = textView;
    
    [self updateTextViewForComponents];
}

- (void)updateTextViewForComponents
{
    [self.stylePicker setTextView:_textView];
    [self.fontInspector setTextView:_textView];
    [self.alignmentInspector setTextView:_textView];
    [self.spacingInspector setTextView:_textView];
    [self.listInspector setTextView:_textView];
}

@end
