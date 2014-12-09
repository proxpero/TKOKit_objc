//
//  TKOResizingTextView.m
//
//  Created by Todd Olsen on 10/31/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOResizingTextView.h"
#import "NSString+Geometrics.h"
//#import "NSString+TKOKit.h"
#import "NSColor+TKOKit.h"

@interface TKOResizingTextView ()

@property (nonatomic) NSLayoutConstraint * heightConstraint;
@property (nonatomic) NSColor * borderColor;
@property (nonatomic) NSColor * highlightBorderColor;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) CGFloat highlightBorderWidth;

@property (nonatomic) CGFloat singleLineHeight;
@property (nonatomic) NSSize inset;
@property (nonatomic) CGFloat minimumHeight;
@property (nonatomic) NSSize padding;

@end

@implementation TKOResizingTextView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    [self configure];
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    [self configure];
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect textContainer:(NSTextContainer *)container
{
    self = [super initWithFrame:frameRect textContainer:container];
    [self configure];
    return self;
}

- (void)setFont:(NSFont *)font
{
    [super setFont:font];
    [self configure];
}

- (void)setFont:(NSFont *)font range:(NSRange)range
{
    [super setFont:font range:range];
    [self configure];
}

- (void)setTextContainerInset:(NSSize)textContainerInset
{
    [super setTextContainerInset:textContainerInset];
    [self configure];
}

- (void)configure
{
    NSUserDefaults * standardDefaults = [NSUserDefaults standardUserDefaults];
    
    if (!_borderColor) {
        _borderColor = [NSColor colorWithString:[standardDefaults stringForKey:@"TKOTextViewBorderColor"]];
    }
    
    if (!_highlightBorderColor) {
        _highlightBorderColor = [NSColor colorWithHexString:[standardDefaults stringForKey:@"TKOTextViewHighlightBorderColor"]];
    }
    
    _borderWidth = [standardDefaults floatForKey:@"TKOTextViewBorderWidth"];
    _highlightBorderWidth = [standardDefaults floatForKey:@"TKOTextViewHighlightBorderWidth"];
    
    self.shouldOutlineBorder = YES;
    self.shouldHighlightBorder = YES;
    
    if (!self.wantsLayer) {
        self.wantsLayer = YES;
        self.layer.borderColor = [_borderColor CGColor];
        self.layer.cornerRadius = [standardDefaults floatForKey:@"TKOTextViewCornerRadius"];
        self.layer.borderWidth = self.shouldOutlineBorder ? _borderWidth : 0.0;
    }
    
    self.richText = YES;
    self.allowsUndo = YES;
    
    self.singleLineHeight   = ceilf(self.font.ascender + fabsf(self.font.descender));
    
    if (NSEqualSizes(self.textContainerInset, NSZeroSize)) {
        self.textContainerInset = NSMakeSize(_singleLineHeight, _singleLineHeight);
    }
    
    NSSize inset = self.textContainerInset;
    
    CGFloat heightInset        = NSEqualSizes(inset, NSZeroSize) ? self.singleLineHeight : inset.height;
    CGFloat verticalPadding    = NSEqualSizes(inset, NSZeroSize) ? self.singleLineHeight : inset.height;
    CGFloat widthInset         = NSEqualSizes(inset, NSZeroSize) ? self.singleLineHeight : inset.width;
    CGFloat horizontalPadding  = NSEqualSizes(inset, NSZeroSize) ? self.singleLineHeight : inset.width;
    
    self.inset = NSMakeSize(widthInset, heightInset);
    self.padding = NSMakeSize(horizontalPadding, verticalPadding);
    
    self.minimumHeight      = self.singleLineHeight + verticalPadding + verticalPadding;

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


- (void)viewWillDraw
{
    [super viewWillDraw];
    [self resizeTextView];
}


- (void)resizeTextView
{
    CGFloat height = [self.attributedString heightForWidth:self.bounds.size.width - (self.padding.width + self.padding.width)]; // text width without padding
    height += (self.padding.height + self.padding.height); // vertical padding
    if (height < self.minimumHeight) height = self.minimumHeight;
    self.heightConstraint.constant = height;
}

- (BOOL)becomeFirstResponder
{
    if (!self.shouldHighlightBorder) return [super becomeFirstResponder];
    if (![super becomeFirstResponder]) return NO;
    
    self.layer.borderColor = [self.highlightBorderColor CGColor];
    self.layer.borderWidth = self.highlightBorderWidth;
    
    
    
    return YES;
}

- (BOOL)resignFirstResponder
{
    if (![super resignFirstResponder]) return NO;

    if (!self.shouldOutlineBorder) {
        self.layer.borderWidth = 0.0;
    } else {
        self.layer.borderColor = [self.borderColor CGColor];
        self.layer.borderWidth = self.borderWidth;
    }
    
    
    
    return YES;
}

@end
