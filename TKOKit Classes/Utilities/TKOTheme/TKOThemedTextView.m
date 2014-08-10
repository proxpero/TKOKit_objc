//
//  TKOThemedTextView.m
//  TKOThemedTextViewDemo
//
//  Created by Todd Olsen on 7/9/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOThemedTextView.h"
#import "TKOThemeLoader.h"
#import "TKOTheme.h"
#import "NSString+Geometrics.h"

@interface TKOThemedTextView ()

@property (nonatomic) TKOTheme * theme;
@property (nonatomic) NSAttributedString * placeholder;

@end

@implementation TKOThemedTextView
{
    BOOL    _adoptsTextFieldNavigation;
    CGFloat _singleLineHeight;
    CGFloat _heightInset;
    CGFloat _widthInset;
    CGFloat _minimumHeight;
    CGFloat _verticalPadding;
}


- (instancetype)initWithTheme:(TKOTheme *)theme
{
    self = [super initWithFrame:NSZeroRect];
    if (!self) return nil;
    self.translatesAutoresizingMaskIntoConstraints = NO;

    _theme = theme;
    [self configure];
    
    return self;
}


- (instancetype)init { return [self initWithTheme:nil]; }
- (instancetype)initWithFrame:(NSRect)frameRect { return [self initWithTheme:nil]; }

- (void)awakeFromNib
{
    [self configure];
}

- (void)configure
{
    self.allowsUndo = YES;
    self.editable = YES;
    
    if (!_theme) {
        TKOThemeLoader * themeLoader = [[TKOThemeLoader alloc] init];
        _theme                        = [themeLoader defaultTheme];
    }
    
    NSFont  * font                   = [_theme fontForKey:TKOTextEditingFont];
    NSColor * color                  = [_theme colorForKey:TKOTextEditingForegroundColor];
    NSSize    inset                  = [_theme sizeForKey:TKOTextEditingInset];
    _adoptsTextFieldNavigation       = [_theme boolForKey:TKOTextEditingAdoptsTextFieldNavigation];
    
    self.font                        = font;
    self.typingAttributes            = @{NSFontAttributeName: font,
                                         NSForegroundColorAttributeName: color};
    self.textContainerInset          = inset;
    
    NSString * placeholderString     = [_theme stringForKey:TKOTextEditingPlaceholder];
    NSColor  * placeholderColor      = [_theme colorForKey:TKOTextEditingPlaceholderColor];
    
    self.placeholder                 = [[NSAttributedString alloc] initWithString:placeholderString ?: @""
                                                                       attributes:@{NSForegroundColorAttributeName: placeholderColor ?: [NSColor lightGrayColor],
                                                                                    NSFontAttributeName: font}];
    
    _singleLineHeight        = ceilf(font.ascender + fabsf(font.descender));
    CGFloat heightInset      = NSEqualSizes(inset, NSZeroSize) ? _singleLineHeight : inset.height;
    _verticalPadding         = heightInset + heightInset;
    _minimumHeight           = _singleLineHeight + _verticalPadding;
    
    if (!_heightConstraint) {
        _heightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1
                                                          constant:_minimumHeight];
        [self addConstraint:_heightConstraint];
    } else {
        _heightConstraint.constant = _minimumHeight;
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    static CGFloat margin = CGFLOAT_MAX; if (margin == CGFLOAT_MAX) margin = _singleLineHeight - _widthInset;
    
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
    CGFloat height = [self.attributedString heightForWidth:self.bounds.size.width - _verticalPadding]; // text width without padding
    height += _verticalPadding; // vertical padding
    if (height < _minimumHeight) height = _minimumHeight;
    self.heightConstraint.constant = height;
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
