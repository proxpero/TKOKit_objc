//
//  TKOAppDelegate.m
//  TKODisclosureViewDemo
//
//  Created by Todd Olsen on 2/12/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOAppDelegate.h"
#import "TKODisclosingViewController.h"
#import "TKOFontInspectorViewController.h"
#import "TKODisclosingViewController.h"

@interface TKOAppDelegate ()

@property (weak) IBOutlet NSScrollView *scrollView;
//@property (strong, nonatomic) TKOFontInspectorViewController * fontInspector;
//@property (strong, nonatomic) TKODisclosingViewController * fontDVC;

@property (strong, nonatomic) TKODisclosingViewController * buttonsDVC;
@property (weak) IBOutlet NSView *buttonsView;


@end

@implementation TKOAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.buttonsDVC = [[TKODisclosingViewController alloc] init];
    [self.buttonsDVC setContentView:self.buttonsView];
    
    NSStackView * stackView = [NSStackView stackViewWithViews:@[
                                                                self.buttonsDVC.view
                                                                ]];
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    stackView.alignment = NSLayoutAttributeCenterX;
    stackView.spacing = 0; // No spacing between the disclosure views
    [stackView setHuggingPriority:NSLayoutPriorityDefaultHigh
                   forOrientation:NSLayoutConstraintOrientationHorizontal];
    [self.scrollView setDocumentView:stackView];
}

@end
