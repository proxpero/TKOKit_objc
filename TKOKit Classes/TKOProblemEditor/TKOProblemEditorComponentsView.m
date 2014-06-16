//
//  TKOProblemEditorComponentsView.m
//  Keystone
//
//  Created by Todd Olsen on 5/30/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOProblemEditorComponentsView.h"
#import "TKOProblemEditorTextView.h"

#import "NSView+TKOKit.h"
#import "TKOComponentView.h" // protocol

@interface TKOProblemEditorComponentsView () <NSTextViewDelegate>

@end

@implementation TKOProblemEditorComponentsView

- (NSView *)initialResponder
{
    id <TKOComponentView> initialResponder = self.views.firstObject;
    return [initialResponder firstKeyView];
}

- (instancetype)init
{
    self = [super initWithFrame:NSZeroRect];
    if (!self) return nil;

    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.orientation = NSUserInterfaceLayoutOrientationVertical;
    self.alignment = NSLayoutAttributeCenterX;
    self.spacing = 1;
    [self setHuggingPriority:NSLayoutPriorityDefaultHigh
              forOrientation:NSLayoutConstraintOrientationHorizontal];

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
    [self addView:component inGravity:NSStackViewGravityTop];
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[component]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(component)]
     ];
    [self resetKeyViewFlow];
}

- (void)insertComponent:(NSView *)component atIndex:(NSUInteger)index
{
    [self insertView:component atIndex:index inGravity:NSStackViewGravityTop];
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[component]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(component)]
     ];
    [self resetKeyViewFlow];
}

- (void)removeComponent:(NSView *)component
{
    [self removeView:component];
    [self resetKeyViewFlow];
}

- (void)componentDidUpdateHtmlNotification:(NSNotification *)notification
{
    NSMutableString * html = [NSMutableString new];
    [html appendString:@"<div class='problem'>\n"];
    for (id <TKOComponentView> item in self.views)
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
    
    for (id <TKOComponentView> component in self.views)
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

