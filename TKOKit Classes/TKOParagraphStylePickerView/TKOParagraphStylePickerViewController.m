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

- (id)init
{
    self = [self initWithNibName:@"TKOParagraphStylePickerViewController"
                          bundle:nil];
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

- (IBAction)showPopover:(id)sender
{
    [self.popover showRelativeToRect:[sender bounds]
                              ofView:sender
                       preferredEdge:NSMinYEdge];
}
@end
