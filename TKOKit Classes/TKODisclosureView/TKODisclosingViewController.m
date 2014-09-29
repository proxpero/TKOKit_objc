//
//  TKODisclosingViewController.m
//  TKODisclosureViewDemo
//
//  Created by Todd Olsen on 2/12/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKODisclosingViewController.h"
@import QuartzCore;

@interface TKODisclosingViewController ()

@property (weak) IBOutlet NSButton *disclosureButton;
@property (weak) IBOutlet NSTextField *titleField;
@property (weak) IBOutlet NSView *headerView;

@property (strong, nonatomic) NSLayoutConstraint * heightConstraint;

- (IBAction)toggleContentViewAction:(id)sender;

@end

@implementation TKODisclosingViewController
{
    BOOL _disclosureIsClosed;
}

- (id)init
{
    self = [super initWithNibName:@"TKODisclosingViewController"
                           bundle:nil];
    if (!self)
        return nil;
    
    return self;
}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    [self.titleField setStringValue:title];
}

- (void)setContentView:(NSView *)contentView
{
    if (_contentView == contentView)
        return;
    
    [_contentView removeFromSuperview];
    _contentView = contentView;
    [self.view addSubview:_contentView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_contentView)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_headerView][_contentView]-(0@600)-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(_headerView, _contentView)]];
}

- (void)awakeFromNib
{
    _disclosureIsClosed = NO;
}

- (IBAction)toggleContentViewAction:(id)sender
{
    if (!_disclosureIsClosed)
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
                                                                  constant:distanceFromHeaderToBottom];
        }
        self.heightConstraint.constant = distanceFromHeaderToBottom;
        [self.view addConstraint:self.heightConstraint];
        
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            self.heightConstraint.animator.constant = 0;
        } completionHandler:^{
            self->_disclosureIsClosed = YES;
        }];
    }
    else
    {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            self.heightConstraint.animator.constant -= self.contentView.frame.size.height;
        } completionHandler:^{
            [self.view removeConstraint:self.heightConstraint];
            self->_disclosureIsClosed = NO;
        }];
    }
}

@end
