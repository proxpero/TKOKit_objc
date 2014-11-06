//
//  TKOProblemEditorView.m
//  Keystone
//
//  Created by Todd Olsen on 6/13/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOProblemEditorView.h"
#import "TKOProblemEditorHeaderView.h"
#import "TKOProblemEditorComponentsView.h"

#import "NSView+TKOKit.h"
#import "TKOFlippedClipView.h"

#import "TKOPreludeEditorView.h"
#import "TKOQuestionEditorView.h"
#import "TKORomanEditorView.h"
#import "TKOChoicesEditorView.h"

@interface TKOProblemEditorView ()

@property (nonatomic) TKOProblemEditorHeaderView * header;
@property (nonatomic) TKOProblemEditorComponentsView * components;

@end

@implementation TKOProblemEditorView

- (id)init
{
    self = [super initWithFrame:NSZeroRect];
    if (!self) return nil;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    _header = [[TKOProblemEditorHeaderView alloc] init];
    
    NSScrollView * scrollView = [NSView viewWithClass:[NSScrollView class]];
    TKOFlippedClipView * clipView = [TKOFlippedClipView new];
    clipView.backgroundColor = [NSColor darkGrayColor];
    
    scrollView.borderType              = NSNoBorder;
    scrollView.hasHorizontalScroller   = NO;
    scrollView.hasVerticalScroller     = YES;
    scrollView.autohidesScrollers      = YES;
    scrollView.contentView             = clipView;
    
    [self setSubviews:@[_header, scrollView]];
    
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
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_header][scrollView]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_header, scrollView)]
     ];
    
    _components = [[TKOProblemEditorComponentsView alloc] init];
    

    
    scrollView.documentView = _components;
    [clipView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_components]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_components)]
     ];
    
    [self startObserving];
    
//    TKOPreludeEditorView   * prelude  = [[TKOPreludeEditorView alloc] init];
//    TKOQuestionEditorView  * question = [[TKOQuestionEditorView alloc] init];
//    TKORomanEditorView     * roman    = [[TKORomanEditorView alloc] initWithCount:3];
//    TKOChoicesEditorView   * choices  = [[TKOChoicesEditorView alloc] initWithCount:5];

//    [_components setComponents:@[prelude, question, roman, choices]];

    return self;
}

- (void)startObserving
{
    [_components addObserver:_header
                  forKeyPath:@"html"
                     options:0
                     context:NULL];
    
    [_header addObserver:_components
              forKeyPath:@"components"
                 options:0
                 context:NULL];
}

- (void)stopObserving
{
    [_components removeObserver:_header forKeyPath:@"html"];
    [_header removeObserver:_components forKeyPath:@"components"];
}

@end
