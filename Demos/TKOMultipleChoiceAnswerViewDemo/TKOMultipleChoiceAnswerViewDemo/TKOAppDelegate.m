//
//  TKOAppDelegate.m
//  TKOMultipleChoiceAnswerViewDemo
//
//  Created by Todd Olsen on 3/19/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOAppDelegate.h"
#import "TKOMultipleChoiceAnswerViewController.h"
#import "NSView+TKOKit.h"

@interface TKOAppDelegate ()

@property (strong, nonatomic) TKOMultipleChoiceAnswerViewController * answerVC;

@end

@implementation TKOAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.answerVC = [[TKOMultipleChoiceAnswerViewController alloc] init];
    NSView * subview = self.answerVC.view;
    [self.window.contentView addSubview:subview];
    [self.window.contentView addConstraint:
     [NSLayoutConstraint constraintWithItem:subview
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.window.contentView
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]
    ];

    [self.window.contentView addConstraint:
     [NSLayoutConstraint constraintWithItem:subview
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.window.contentView
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1
                                   constant:0]
     ];
}

@end
