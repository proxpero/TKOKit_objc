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

#import "TKOThemeLoader.h"
#import "TKOTheme.h"

static TKOTheme * theme = nil;

@interface TKOProblemEditorTextView ()

@property (nonatomic) NSAttributedString * placeholder;
@property (strong) NSLayoutConstraint * heightConstraint;
@property (nonatomic) CGFloat minHeight;
@property (nonatomic) CGFloat doubleInset;

@end

@implementation TKOProblemEditorTextView

- (instancetype)init
{
    return [self initWithPlaceholder:@""];
}

- (instancetype)initWithPlaceholder:(NSString *)placeholder
{
    self = [super initWithFrame:NSZeroRect];
    if (!self) return nil;
    
    if (!theme)
    {
        TKOThemeLoader * themeLoader = [[TKOThemeLoader alloc] init];
        theme = [themeLoader defaultTheme];
    }
    
    NSFont  * font      = [theme fontForKey:@"TKOProblemEditorFont"];
    NSSize    textInset = [theme sizeForKey:@"TKOProblemEditorTextInset"];
    NSColor * textColor = [theme colorForKey:@"TKOProblemEditorTextColor"];
    
    self.font = font;
    CGFloat singleLineHeight = ceilf(font.ascender + fabsf(font.descender));
    CGFloat heightInset      = NSEqualSizes(textInset, NSZeroSize) ? singleLineHeight : textInset.height;
    _minHeight               = singleLineHeight + heightInset + heightInset;
    _doubleInset             = heightInset + heightInset;
    
    [self setTypingAttributes:@{NSForegroundColorAttributeName: textColor,
                                NSFontAttributeName: self.font}];
    
    if (!placeholder) placeholder = @""; // Make sure 'placeholder' (plaintext) is not-nil
    
    _placeholder = [[NSAttributedString alloc] initWithString:placeholder
                                                   attributes:@{NSForegroundColorAttributeName: [NSColor lightGrayColor],
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
                                                      constant:_minHeight];
    [self addConstraint:_heightConstraint];
    
    return self;
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
    
    static CGFloat margin = 0.0;
    if (margin == 0.0)
    {
        margin = [theme floatForKey:@"TKOProblemEditorFontSize"] - [theme floatForKey:@"TKOProblemEditorTextInsetWidth"];
    }
    
    if ([[self string] isEqualToString:@""] && self != [[self window] firstResponder])
        [self.placeholder drawAtPoint:NSMakePoint(margin - 1, 1)];
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
    CGFloat height = [self.attributedString heightForWidth:self.bounds.size.width - _doubleInset]; // text width without padding
    height += _doubleInset; // vertical padding
    if (height < _minHeight) height = _minHeight;
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
