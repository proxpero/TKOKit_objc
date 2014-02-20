//
//  TKOParagraphStylePickerViewController.m
//  TKOParagraphStylePickerViewDemo
//
//  Created by Todd Olsen on 2/17/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOParagraphStylePickerViewController.h"

@interface TKOParagraphStylePickerViewController ()
@property (strong) IBOutlet NSPopover *popover;

- (IBAction)showPopover:(id)sender;

@end

@implementation TKOParagraphStylePickerViewController

- (id)initWithTextView:(TKOTextView *)textView
{
    self = [self initWithNibName:@"TKOParagraphStylePickerViewController"
                          bundle:nil];
    [self setTextView:textView];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (!self)
        return nil;
    
    if (self.view) {
        self.view.wantsLayer = YES;
        self.view.layer.backgroundColor = [[NSColor whiteColor] CGColor];
    }
    
    [self.popover setAppearance:NSPopoverAppearanceMinimal];
    [self.popover setBehavior:NSPopoverBehaviorTransient];
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setTextView:(TKOTextView *)textView
{
    if (_textView == textView)
        return;
    NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self
                             name:NSTextViewDidChangeSelectionNotification
                           object:_textView];
    
    _textView = textView;
    
    [defaultCenter addObserver:self
                      selector:@selector(textViewDidChangeParagraphStyle:)
                          name:NSTextViewDidChangeSelectionNotification
                        object:textView];
}

- (void)textViewDidChangeParagraphStyle:(NSNotification *)notification
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (IBAction)showPopover:(id)sender
{
    [self.popover showRelativeToRect:[sender bounds]
                              ofView:sender
                       preferredEdge:NSMinYEdge];
}
@end
