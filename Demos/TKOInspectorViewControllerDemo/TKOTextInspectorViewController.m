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
@property (strong, nonatomic) IBOutlet NSScrollView                          * inspectorScrollView;

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
    
    [self setTextView:textView];

    self.fontInspector      = [[TKOFontInspectorViewController alloc] initWithTextView:textView];
    self.alignmentInspector = [[TKOAlignmentInspectorViewController alloc] initWithTextView:textView];
    self.spacingInspector   = [[TKOSpacingInspectorViewController alloc] initWithTextView:textView];
    self.listInspector      = [[TKOListsInspectorViewController alloc] initWithTextView:textView];

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
}

- (void)setTextView:(TKOTextView *)textView
{
    if (_textView == textView)
        return;
    _textView = textView;
    
    [self.stylePicker setTextView:_textView];
}

@end
