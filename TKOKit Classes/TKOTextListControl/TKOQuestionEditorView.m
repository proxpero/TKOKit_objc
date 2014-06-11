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

@interface TKOQuestionEditorView () <NSTextViewDelegate>

@property (nonatomic) TKOProblemEditorTextView * textView;
@property (nonatomic) NSString * html;

@end

@implementation TKOQuestionEditorView

- (instancetype)init
{
    self = [super initWithFrame:NSZeroRect];
    if (!self) return nil;
    
    self.wantsLayer = YES;
    self.layer.backgroundColor = [[NSColor whiteColor] CGColor];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    _textView = [[TKOProblemEditorTextView alloc] initWithFont:[NSFont fontWithName:@"Baskerville"
                                                                              size:20.0]
                                                   placeholder:@"Enter Question"
                                                     textInset:NSMakeSize(7, 7)];
    _textView.delegate = self;
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

#pragma mark - Text View Delegate

- (void)textDidChange:(NSNotification *)notification
{
    NSMutableString * html = [NSMutableString new];
    
    [html appendFormat:@"<p class='question'>%@</p>", self.textView.string];
    self.html = html;
}

#pragma mark - Component Delegate

- (NSView *)firstKeyView { return self.textView; }
- (NSView *)lastKeyView  { return self.textView; }

@end
