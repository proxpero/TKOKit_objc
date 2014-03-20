//
//  TKODifficultyInspectorViewController.m
//  TKODifficultyInspectorViewDemo
//
//  Created by Todd Olsen on 3/19/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKODifficultyInspectorViewController.h"
@import QuartzCore;

@interface TKODifficultyInspectorViewController ()



# pragma mark - View Disclosure

@property (strong) IBOutlet NSView *headerView;
@property (strong) IBOutlet NSView *contentView;
@property (strong) NSLayoutConstraint *heightConstraint;

- (IBAction)toggleDisclosureButton:(id)sender;

@end

@implementation TKODifficultyInspectorViewController

- (id)init
{
    self = [super initWithNibName:@"TKODifficultyInspectorViewController"
                           bundle:nil];
    if (!self)
        return nil;
    
    
    
    
    
    
    return self;
}

- (IBAction)toggleDisclosureButton:(id)sender
{
    BOOL isClosed = [sender state];
    if (!isClosed)
    {        
        CGFloat distanceFromHeaderToBottom = NSMinY(self.view.bounds) - NSMinY(self.headerView.frame);
        if (!self.heightConstraint)
        {
            self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.headerView
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1
                                                                  constant:distanceFromHeaderToBottom + 1];
        }
        self.heightConstraint.constant = distanceFromHeaderToBottom + 1;
        [self.view addConstraint:self.heightConstraint];
        
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            self.heightConstraint.animator.constant = 0;
        } completionHandler:nil];
    }
    else
    {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            self.heightConstraint.animator.constant -= self.contentView.frame.size.height;
        } completionHandler:^{
            [self.view removeConstraint:self.heightConstraint];
        }];
    }
}

@end
