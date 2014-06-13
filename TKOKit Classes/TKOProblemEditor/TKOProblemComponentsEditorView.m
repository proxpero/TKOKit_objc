//
//  TKOProblemComponentsEditorView.m
//  ProblemEditor
//
//  Created by Todd Olsen on 5/30/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOProblemComponentsEditorView.h"
#import "TKOProblemEditorHeaderView.h"
#import "TKOProblemEditorTextView.h"
#import "TKOComponentEditorView.h"

#import "NSView+TKOKit.h"
#import "TKOFlippedClipView.h"
#import "TKOComponentView.h" // protocol

#import "TKOPreludeEditorView.h"
#import "TKOQuestionEditorView.h"
#import "TKORomanEditorView.h"
#import "TKOChoicesEditorView.h"

@interface TKOProblemComponentsEditorView () <NSTextViewDelegate>

@property (nonatomic) NSScrollView * scrollView;
@property (nonatomic) NSStackView * stackView;

@end

@implementation TKOProblemComponentsEditorView

- (NSView *)initialResponder
{
    id <TKOComponentView> initialResponder = self.stackView.views.firstObject;
    return [initialResponder firstKeyView];
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (!self) return nil;
    self.translatesAutoresizingMaskIntoConstraints = NO;

    TKOProblemEditorHeaderView * header = [[TKOProblemEditorHeaderView alloc] init];

    TKOFlippedClipView * clipView = [[TKOFlippedClipView alloc] init];
    clipView.backgroundColor = [NSColor darkGrayColor];
    
    _scrollView                         = [NSView viewWithClass:[NSScrollView class]];
    _scrollView.borderType              = NSNoBorder;
    _scrollView.hasHorizontalScroller   = NO;
    _scrollView.hasVerticalScroller     = YES;
    _scrollView.autohidesScrollers      = YES;
    _scrollView.contentView             = clipView;
    
    [self setSubviews:@[header, _scrollView]];
    
    for (NSView * view in self.subviews)
    {
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                 options:0
                                                 metrics:nil
                                                   views:NSDictionaryOfVariableBindings(view)]
         ];
        
    }
    
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[header][_scrollView]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(header, _scrollView)]
     ];
    
    _stackView = [[NSStackView alloc] initWithFrame:NSZeroRect];
    _stackView.translatesAutoresizingMaskIntoConstraints = NO;
    _stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    _stackView.alignment = NSLayoutAttributeCenterX;
    _stackView.spacing = 1;
    [_stackView setHuggingPriority:NSLayoutPriorityDefaultHigh
                    forOrientation:NSLayoutConstraintOrientationHorizontal];

    _scrollView.documentView = _stackView;
    
    TKOPreludeEditorView   * prelude  = [[TKOPreludeEditorView alloc] init];
    TKOQuestionEditorView  * question = [[TKOQuestionEditorView alloc] init];
    TKORomanEditorView     * roman    = [[TKORomanEditorView alloc] initWithCount:3];
    TKOChoicesEditorView   * choices  = [[TKOChoicesEditorView alloc] initWithCount:5];

    [self setComponents:@[prelude, question, roman, choices]];
    
    _scrollView.documentView = _stackView;
    [_scrollView.contentView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_stackView]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_stackView)]
     ];

    return self;
}

- (void)setComponents:(NSArray *)components
{
    for (NSView * component in components)
    {
        [self addComponent:component];
    }
}

- (void)addComponent:(NSView *)component
{
    [self.stackView addView:component inGravity:NSStackViewGravityTop];
    [self.stackView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[component]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(component)]
     ];
    [self resetKeyViewFlow];
}

- (void)insertComponent:(NSView *)component atIndex:(NSUInteger)index
{
    [self.stackView insertView:component atIndex:index inGravity:NSStackViewGravityTop];
    [self.stackView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[component]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(component)]
     ];
    [self resetKeyViewFlow];
}

- (void)removeComponent:(NSView *)component
{
    [self.stackView removeView:component];
    [self resetKeyViewFlow];
}

- (void)componentDidUpdateHtmlNotification:(NSNotification *)notification
{
    NSMutableString * html = [NSMutableString new];
    [html appendString:@"<div class='problem'>\n"];
    for (id <TKOComponentView> item in self.stackView.views)
    {
        NSString * s = [item html];
        if (s && s.length > 0) [html appendFormat:@"%@\n", s];
    }
    [html appendString:@"</div> <!--problem-->\n"];
    self.html = html.copy;
}

- (void)resetKeyViewFlow
{
    id <TKOComponentView> prev = nil;
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
    
    for (id <TKOComponentView> component in self.stackView.views)
    {
        [center addObserver:self
                   selector:@selector(componentDidUpdateHtmlNotification:)
                       name:TKOComponentDidUpdateHtmlNotification
                     object:nil];
        [[prev lastKeyView] setNextKeyView:[component firstKeyView]];
        prev = component;
    }
}

@end

NSString * const TKOComponentDidUpdateHtmlNotification = @"TKOComponentDidUpdateHtmlNotification";

