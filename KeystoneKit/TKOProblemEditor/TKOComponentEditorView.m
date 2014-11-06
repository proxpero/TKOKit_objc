//
//  TKOComponentEditorView.m
//  ProblemEditor
//
//  Created by Todd Olsen on 6/11/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOComponentEditorView.h"
#import "TKOProblemEditorTextView.h"
#import "NSView+TKOKit.h"
#import "TKOTheme.h"
#import "TKOThemeLoader.h"

@interface TKOComponentEditorView () <NSTextViewDelegate>

@property (nonatomic) TKOProblemEditorTextView * textView;

@end

@implementation TKOComponentEditorView

- (instancetype)initWithPlaceholder:(NSString *)placeholder
{
    self = [super initWithFrame:NSZeroRect];
    if (!self) return nil;
    
    self.wantsLayer = YES;
    self.layer.backgroundColor = [[NSColor whiteColor] CGColor];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;

    TKOThemeLoader * themeLoader = [[TKOThemeLoader alloc] init];
    TKOTheme * theme = themeLoader.defaultTheme;
    
    _textView = [[TKOProblemEditorTextView alloc] initWithPlaceholder:placeholder];
    _textView.delegate = self;
    [self setSubviews:@[_textView]];
    
    CGFloat margin;
    
    margin = [theme floatForKey:@"TKOProblemEditorFontSize"] - [theme floatForKey:@"TKOProblemEditorTextInsetWidth"];
    NSString * hFormat = [NSString stringWithFormat:@"H:|-%f-[_textView]-%f-|", margin, margin];
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:hFormat
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_textView)]
     ];
    
    margin = (CGFloat)[theme floatForKey:@"TKOProblemEditorFontSize"] - (CGFloat)[theme floatForKey:@"TKOProblemEditorTextInsetHeight"];
    NSString * vFormat = [NSString stringWithFormat:@"V:|-%f-[_textView]-%f-|", margin, margin];
    
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:vFormat
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_textView)]
     ];
    
    return self;
}

- (void)updateHtmlWithString:(NSString *)string
{
    NSAssert(0, @"Subclasses must override: %s", __PRETTY_FUNCTION__);
}

- (NSImage *)image
{
    NSAssert(0, @"Subclasses must override: %s", __PRETTY_FUNCTION__);
    return nil;
}

- (NSString *)title
{
    NSAssert(0, @"Subclasses must override: %s", __PRETTY_FUNCTION__);
    return nil;
}

#pragma mark - Text View Delegate

- (void)textDidChange:(NSNotification *)notification
{
    [self updateHtmlWithString:self.textView.string];
    [[NSNotificationCenter defaultCenter] postNotificationName:TKOComponentDidUpdateHtmlNotification object:self];
}

#pragma mark - Component Delegate

- (NSView *)firstKeyView { return self.textView; }
- (NSView *)lastKeyView  { return self.textView; }

@end
