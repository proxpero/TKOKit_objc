//
//  TKOPreludeEditorView.m
//  ProblemEditor
//
//  Created by Todd Olsen on 6/9/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOPreludeEditorView.h"
#import "TKOProblemEditorTextView.h"

#import "NSView+TKOKit.h"

@implementation TKOPreludeEditorView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (!self) return nil;
    
    self.wantsLayer = YES;
    self.layer.backgroundColor = [[NSColor whiteColor] CGColor];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    _textView = [[TKOProblemEditorTextView alloc] initWithFont:[NSFont fontWithName:@"Baskerville"
                                                                               size:20.0]
                                                   placeholder:@"Enter Prelude"
                                                     textInset:NSMakeSize(7, 7)];
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

@end
