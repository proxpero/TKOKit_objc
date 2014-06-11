//
//  TKOProblemEditorTextView.m
//  ProblemEditor
//
//  Created by Todd Olsen on 6/6/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOProblemEditorTextView.h"
#import "NSString+Geometrics.h"
#import "TKOProblemComponentsEditorView.h"
#import "NSColor+TKOKit.h"

@interface TKOProblemEditorTextView ()

@property (nonatomic) NSAttributedString * placeholder;
@property (strong) NSLayoutConstraint * heightConstraint;
@property (nonatomic) CGFloat heightInset;

@end

@implementation TKOProblemEditorTextView

- (instancetype)initWithFont:(NSFont *)font
                 placeholder:(NSString *)placeholder
                   textInset:(NSSize)textInset
{
    self = [super initWithFrame:NSZeroRect];
    if (!self) return nil;
    
    self.font = font ? font : [NSFont systemFontOfSize:[NSFont systemFontSize]];
    [self setTypingAttributes:@{NSForegroundColorAttributeName: [NSColor colorWithHexString:@"2e393e"],
                                NSFontAttributeName: self.font}];
    _singleLineHeight = ceilf(font.ascender + (font.descender * -1));
    _heightInset = NSEqualSizes(textInset, NSZeroSize) ? _singleLineHeight : textInset.height;

    if (!placeholder) placeholder = @""; // Make sure 'placeholder' (plaintext) is not-nil
    
    _placeholder = [[NSAttributedString alloc] initWithString:placeholder
                                                   attributes:@{NSForegroundColorAttributeName: [NSColor grayColor],
                                                                NSFontAttributeName: font}];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.allowsUndo = YES;
    self.textContainerInset = textInset;
    
    _heightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:_singleLineHeight + _heightInset + _heightInset];
    [self addConstraint:_heightConstraint];
    
    return self;
}

- (void)setTextContainerInset:(NSSize)inset
{
    [super setTextContainerInset:inset];
    _heightInset = inset.height;
    [self resizeTextView];
}

- (void)setFont:(NSFont *)font
{
    [super setFont:font];
    _singleLineHeight = ceilf(font.ascender + (font.descender * -1));
    [self resizeTextView];
}

- (BOOL)becomeFirstResponder
{
    [self setNeedsDisplay:YES];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    [self setNeedsDisplay:YES];
    return [super resignFirstResponder];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    if ([[self string] isEqualToString:@""] && self != [[self window] firstResponder])
        [self.placeholder drawAtPoint:NSMakePoint(13 - 1, 1)]; // 13 is leading constraint constant
}

- (void)didChangeText
{
    [super didChangeText];
    [self resizeTextView];
}

- (void)setFrameSize:(NSSize)newSize
{
    [super setFrameSize:newSize];
    [self resizeTextView];
}

- (void)resizeTextView
{
    CGFloat minHeight = _singleLineHeight + _heightInset + _heightInset;
    CGFloat height = [self.attributedString heightForWidth:self.bounds.size.width - (_heightInset + _heightInset)];
    height = height + _heightInset + _heightInset; // Why add then subtract??
    if (height < minHeight) height = minHeight;
    self.heightConstraint.constant = height;
}

- (void)keyDown:(NSEvent *)theEvent
{    
    unsigned short left     = 123;
    unsigned short right    = 124;
    unsigned short up       = 126;
    unsigned short down     = 125;
    unsigned short tab      = 48;
    unsigned short enter    = 36;
    
    unsigned short keyCode = theEvent.keyCode;
    NSRange selectedRange = self.selectedRange;
    BOOL isAtFirstPosition = NSEqualRanges(selectedRange, NSMakeRange(0, 0));
    BOOL isAtLastPosition = NSEqualRanges(selectedRange, NSMakeRange(self.string.length, 0));
    
    if (((keyCode == left) && isAtFirstPosition) ||
        ((keyCode == up) && isAtFirstPosition))
    {
        [self.window selectKeyViewPrecedingView:self];
    }
    else if (((keyCode == right) && isAtLastPosition) ||
             ((keyCode == down) && isAtLastPosition)  ||
             (keyCode == tab)                         ||
             (keyCode == enter))
    {
        [self.window selectKeyViewFollowingView:self];
    }
    else [super keyDown:theEvent];
}

@end
