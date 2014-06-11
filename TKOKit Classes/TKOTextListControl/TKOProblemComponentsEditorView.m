//
//  TKOProblemComponentsEditorView.m
//  ProblemEditor
//
//  Created by Todd Olsen on 5/30/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOProblemComponentsEditorView.h"
#import "TKOProblemEditorTextView.h"

#import "NSView+TKOKit.h"
#import "TKOFlippedClipView.h"
#import "TKOComponentView.h"
#import "TKOPreludeEditorView.h"
#import "TKOQuestionEditorView.h"
#import "TKORomanEditorView.h"
#import "TKOChoicesEditorView.h"

static void * TKOPrivateKVOContext = &TKOPrivateKVOContext;

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

    NSView * header = [NSView viewWithClass:[NSView class]];
    [header addConstraint:
     [NSLayoutConstraint constraintWithItem:header
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:28]
     ];
    header.wantsLayer = YES;
    header.layer.backgroundColor = [[NSColor blueColor] CGColor];
    
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
    
//    [self addSubviewWithFullSizeConstraints:_scrollView];
    
    _stackView = [[NSStackView alloc] initWithFrame:NSZeroRect];
    _stackView.translatesAutoresizingMaskIntoConstraints = NO;
    _stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    _stackView.alignment = NSLayoutAttributeCenterX;
    _stackView.spacing = 1;
    [_stackView setHuggingPriority:NSLayoutPriorityDefaultHigh
                    forOrientation:NSLayoutConstraintOrientationHorizontal];

    _scrollView.documentView = _stackView;
    
    TKOPreludeEditorView  * prelude  = [[TKOPreludeEditorView alloc] init];
    [prelude addObserver:self forKeyPath:@"html" options:0 context:TKOPrivateKVOContext];
    
    TKOQuestionEditorView * question = [[TKOQuestionEditorView alloc] init];
    [prelude addObserver:self forKeyPath:@"html" options:0 context:TKOPrivateKVOContext];

    TKORomanEditorView    * roman    = [[TKORomanEditorView alloc] init];
    [roman addObserver:self forKeyPath:@"html" options:0 context:TKOPrivateKVOContext];
    
    TKOChoicesEditorView  * choices  = [[TKOChoicesEditorView alloc] init];
    [choices addObserver:self forKeyPath:@"html" options:0 context:TKOPrivateKVOContext];
    
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
    [self resetKeyViewFlow];
}

- (void)resetKeyViewFlow
{
    id <TKOComponentView> prev = nil;
    for (id <TKOComponentView> component in self.stackView.views)
    {
        [[prev lastKeyView] setNextKeyView:[component firstKeyView]];
        prev = component;
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
}

- (void)removeComponent:(NSView *)component
{
    [self.stackView removeView:component];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context != TKOPrivateKVOContext)
    {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
        return;
    }
    
    [self updateHtml];
}

- (void)updateHtml
{
    NSMutableString * html = [NSMutableString new];
    [html appendString:@"<div class='problem'>\n"];
    for (id <TKOComponentView> item in self.stackView.views)
    {
        [html appendFormat:@"%@\n", [item html]];
    }
    [html appendString:@"</div> <!--problem-->\n"];
    NSLog(@"%@", html);
}


@end


