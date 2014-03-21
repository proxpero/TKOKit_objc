//
//  TKOAppDelegate.m
//  TKOMultipleChoiceAnswerViewDemo
//
//  Created by Todd Olsen on 3/19/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOAppDelegate.h"
#import "TKOMultipleChoiceAnswerViewController.h"
#import "TKOMultipleChoiceAnswerView.h"
#import "NSView+TKOKit.h"

@interface TKOAppDelegate () <TKOMultipleChoiceAnswerDataSource>

@property (strong, nonatomic) TKOMultipleChoiceAnswerViewController * answerVC;
@property (strong, nonatomic) TKOMultipleChoiceAnswerView * answerView;

@end

@implementation TKOAppDelegate
{
    NSArray * _titles;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _titles = @[ @"A", @"B", @"C", @"D", @"E" ];
    
    TKOMultipleChoiceAnswerView * answerView = [NSView viewWithClass:[TKOMultipleChoiceAnswerView class]];
    answerView.dataSource = self;
    
    [self.window.contentView addSubview:answerView];
    
    [answerView addConstraint:
     [NSLayoutConstraint constraintWithItem:answerView
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:268]
     ];
    
    [self.window.contentView addConstraint:
     [NSLayoutConstraint constraintWithItem:answerView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.window.contentView
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]
    ];

    [self.window.contentView addConstraint:
     [NSLayoutConstraint constraintWithItem:answerView
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.window.contentView
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1
                                   constant:0]
     ];
 }

- (NSUInteger)multipleChoiceViewNumberOfChoices:(TKOMultipleChoiceAnswerView *)multipleChoiceView
{
    return _titles.count;
}

- (NSString *)multipleChoiceView:(TKOMultipleChoiceAnswerView *)multipleChoiceView
                    titleAtIndex:(NSUInteger)index
{
    return _titles[index];
}

@end
