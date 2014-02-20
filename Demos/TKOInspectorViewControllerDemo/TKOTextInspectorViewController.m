//
//  TKOTextInspectorViewController.m
//  TKOInspectorViewControllerDemo
//
//  Created by Todd Olsen on 2/19/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOTextInspectorViewController.h"
#import "TKOTextSystem.h"

#import "TKOParagraphStylePickerViewController.h"

#import "TKOFontInspectorViewController.h"
#import "TKOAlignmentInspectorViewController.h"
#import "TKOSpacingInspectorViewController.h"
#import "TKOListsInspectorViewController.h"


@interface TKOTextInspectorViewController ()

@property (strong, nonatomic) TKOParagraphStylePickerViewController * stylePicker;
@property (strong, nonatomic) NSScrollView                          * inspectorScrollView;

@property (strong, nonatomic) TKOFontInspectorViewController        * fontInspector;
@property (strong, nonatomic) TKOAlignmentInspectorViewController   * alignmentInspector;
@property (strong, nonatomic) TKOSpacingInspectorViewController     * spacingInspector;
@property (strong, nonatomic) TKOListsInspectorViewController       * listInspector;

@end

@implementation TKOTextInspectorViewController

- (id)initWithTextView:(TKOTextView *)textView
{
    self = [self initWithNibName:@"TKOTextInspectorViewController"
                          bundle:nil];

    [self setTitle:@"Text"];
    
    self.fontInspector      = [[TKOFontInspectorViewController alloc] initWithTextView:textView];
    self.alignmentInspector = [[TKOAlignmentInspectorViewController alloc] initWithTextView:textView];
    self.spacingInspector   = [[TKOSpacingInspectorViewController alloc] initWithTextView:textView];
    self.listInspector      = [[TKOListsInspectorViewController alloc] initWithTextView:textView];

    
    
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

@end
