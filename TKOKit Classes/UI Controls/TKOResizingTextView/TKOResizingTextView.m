//
//  TKOResizingTextView.m
//  TKOResizingTextViewDemo
//
//  Created by Todd Olsen on 7/10/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOResizingTextView.h"
#import "NSString+Geometrics.h"
#import "TKOThemeLoader.h"
#import "TKOTheme.h"

@interface TKOResizingTextView ()

@end

@implementation TKOResizingTextView
{
    BOOL    _adoptsTextFieldNavigation;
    CGFloat _singleLineHeight;
    CGFloat _heightInset;
    CGFloat _widthInset;
    CGFloat _minimumHeight;
    CGFloat _verticalPadding;
    CGFloat _horizontalPadding;
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

- (void)setTheme:(TKOTheme *)theme
{
    if (_theme == theme) return;
    _theme = theme;
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
    
    _singleLineHeight   = ceilf(font.ascender + fabsf(font.descender));
    _heightInset        = NSEqualSizes(inset, NSZeroSize) ? _singleLineHeight : inset.height;
    _verticalPadding    = NSEqualSizes(inset, NSZeroSize) ? _singleLineHeight : inset.height;
    _widthInset         = NSEqualSizes(inset, NSZeroSize) ? _singleLineHeight : inset.width;
    _horizontalPadding  = NSEqualSizes(inset, NSZeroSize) ? _singleLineHeight : inset.width;
    
    _minimumHeight      = _singleLineHeight + _verticalPadding + _verticalPadding;
    
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

- (NSArray *)readablePasteboardTypes {
    return @[NSPasteboardTypeString];
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
    CGFloat height = [self.attributedString heightForWidth:self.bounds.size.width - (_horizontalPadding + _horizontalPadding)]; // text width without padding
    height += (_verticalPadding + _verticalPadding); // vertical padding
    if (height < _minimumHeight) height = _minimumHeight;
    self.heightConstraint.constant = height;
}

@end
