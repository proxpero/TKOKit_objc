//
//  TKOProblemComponentsEditorView.m
//  ProblemEditor
//
//  Created by Todd Olsen on 5/30/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOProblemComponentsEditorView.h"
#import "TKOProblemEditorTextView.h"

#import "TKOPreludeEditorView.h"
#import "TKOQuestionEditorView.h"
#import "TKORomanEditorView.h"
#import "TKOChoicesEditorView.h"

@interface TKOProblemComponentsEditorView ()

@end

@implementation TKOProblemComponentsEditorView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (!self) return nil;
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.orientation = NSUserInterfaceLayoutOrientationVertical;
    self.alignment = NSLayoutAttributeCenterX;
    self.spacing = 1;
    [self setHuggingPriority:NSLayoutPriorityDefaultHigh
              forOrientation:NSLayoutConstraintOrientationHorizontal];    
    
//    NSMutableArray * views = [NSMutableArray new];
    
    
//    [self addPreludeComponent];
    [self addQuestionComponent];
//    [self addRomanComponent];
    [self addChoiceComponent];
    
    return self;
}

- (void)addPreludeComponent
{
    NSView * view = [[TKOPreludeEditorView alloc] initWithFrame:NSZeroRect];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
    
    [self addComponent:view];
}

- (void)addQuestionComponent
{
    TKOQuestionEditorView * view = [[TKOQuestionEditorView alloc] initWithFrame:NSZeroRect];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    view.flowDelegate = self;
    
    
    [self addComponent:view];
}

- (void)addRomanComponent
{
    NSView * view = [[TKORomanEditorView alloc] initWithFrame:NSZeroRect];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
    [self addComponent:view];
}

- (void)addChoiceComponent
{
    TKOChoicesEditorView * view = [[TKOChoicesEditorView alloc] initWithFrame:NSZeroRect];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    view.flowDelegate = self;
    
    [self addComponent:view];

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
}

- (BOOL)componentShouldGoUp:(id)componentView
{
    NSArray * views = self.views;
    NSUInteger index = [views indexOfObject:componentView];
    if (index > 0)
    {
        id <TKOComponentFlowDelegate> nextView = views[index - 1];
        [self.window makeFirstResponder:[nextView bottomResponder]];
    }
    return NO;
}

- (BOOL)componentShouldGoDown:(id)componentView
{
    NSArray * views = self.views;
    NSUInteger index = [views indexOfObject:componentView];
    if (index < views.count - 1)
    {
        id <TKOComponentFlowDelegate> nextView = views[index + 1];
        [self.window makeFirstResponder:[nextView topResponder]];
    }
    return NO;
}

@end


