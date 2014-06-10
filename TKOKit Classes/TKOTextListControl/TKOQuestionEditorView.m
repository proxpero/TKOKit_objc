//
//  TKOQuestionEditorView.m
//  ProblemEditor
//
//  Created by Todd Olsen on 6/9/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOQuestionEditorView.h"
#import "TKOProblemEditorTextView.h"

#import "NSView+TKOKit.h"

@implementation TKOQuestionEditorView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (!self) return nil;
    
    self.wantsLayer = YES;
    self.layer.backgroundColor = [[NSColor whiteColor] CGColor];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    _textView = [[TKOProblemEditorTextView alloc] initWithFont:[NSFont fontWithName:@"Baskerville"
                                                                              size:20.0]
                                                   placeholder:@"Enter Question"
                                                     textInset:NSMakeSize(7, 7)];
    _textView.flowDelegate = self;
    [self setSubviews:@[_textView]];
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-13-[_textView]-13-|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_textView)]
     ];
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-13-[_textView]-13-|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_textView)]
     ];
    
    return self;
}

- (BOOL)componentShouldGoUp:(id)componentView
{
    return [self.flowDelegate componentShouldGoUp:self];
}

- (BOOL)componentShouldGoDown:(id)componentView
{
    return [self.flowDelegate componentShouldGoDown:self];
}

- (NSResponder *)topResponder       { return self.textView; }
- (NSResponder *)bottomResponder    { return self.textView; }

@end
