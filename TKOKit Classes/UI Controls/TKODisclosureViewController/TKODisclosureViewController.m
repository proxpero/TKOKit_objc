//
//  TKODisclosureViewController.m
//
//  Created by Todd Olsen on 11/6/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

@import QuartzCore;
#import "TKODisclosureViewController.h"
#import "NSColor+TKOKit.h"

@interface TKODisclosureViewController ()

@property (strong) NSLayoutConstraint * mainViewHeightConstraint;
@property (strong) IBOutlet NSButton * disclosureButton;
@property (strong) IBOutlet NSView * headerView;
@property (strong) IBOutlet NSView * containerView;

@property (strong) IBOutlet NSTextField * accessoryTextField;

@end

@implementation TKODisclosureViewController

+ (instancetype)newWithViewController:(NSViewController *)viewController
{
    TKODisclosureViewController * vc = [TKODisclosureViewController new];
    vc.contentViewController = viewController;
    vc.label = viewController.title;
    
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.wantsLayer = YES;
//    self.view.layer.backgroundColor = [[NSColor colorWithCalibratedRed:241.0/255.0
//                                                                 green:243.0/255.0
//                                                                  blue:245.0/255.0
//                                                                 alpha:1.0] CGColor];
//    self.view.layer.backgroundColor = [[NSColor controlColor] CGColor];
    self.view.layer.backgroundColor = [[NSColor colorWithHexString:@"ecedef"] CGColor];
    [self configureSubviews];
//    [self setDisclosure:NO];
}

- (void)configureSubviews
{
    NSDictionary * views;
   
    if (self.containerView) {
        [self.containerView setSubviews:@[ self.contentViewController.view ]];
        views = @{ @"content": self.contentViewController.view};
        [self.containerView addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[content]|"
                                                 options:0
                                                 metrics:nil
                                                   views:views]
         ];
        [self.containerView addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[content]|"
                                                 options:0
                                                 metrics:nil
                                                   views:views]
         ];
    }
}

//- (void)setContentView:(NSView *)contentView
//{
//    if (_contentView == contentView) return;
//    _contentView = contentView;
//    [self configureSubviews];
//}

- (void)setContentViewController:(NSViewController *)contentViewController
{
    if (_contentViewController == contentViewController) return;
    _contentViewController = contentViewController;
    [self configureSubviews];
}

- (IBAction)toggleDisclosureAction:(id)sender
{
    [self setDisclosure:[sender state]];
}

- (void)setDisclosure:(BOOL)open
{
    CGFloat distanceFromHeaderToBottom = NSMinY(self.view.bounds) - NSMinY(self.headerView.frame);

    if (!self.mainViewHeightConstraint)
    {
        self.mainViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.headerView
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.view
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1
                                                                      constant:distanceFromHeaderToBottom];
    }
    
    if (open) {

        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            self.mainViewHeightConstraint.animator.constant -= self.containerView.frame.size.height;
            self.accessoryTextField.animator.alphaValue = 0.0;
        } completionHandler:^{
            [self.view removeConstraint:self.mainViewHeightConstraint];
            self.accessoryTextField.hidden = YES;
        }];
        
    } else {
       
        self.mainViewHeightConstraint.constant = distanceFromHeaderToBottom;
        [self.view addConstraint:self.mainViewHeightConstraint];
        
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            self.mainViewHeightConstraint.animator.constant = 0;
            self.accessoryTextField.animator.alphaValue = 1.0;
        } completionHandler:^{
            self.accessoryTextField.hidden = NO;
        }];
    
    }
}

@end
