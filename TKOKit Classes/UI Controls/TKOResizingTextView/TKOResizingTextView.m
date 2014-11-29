//
//  TKOResizingTextView.m
//
//  Created by Todd Olsen on 10/31/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOResizingTextView.h"
#import "NSString+Geometrics.h"

@interface TKOResizingTextView ()

@property (nonatomic) NSLayoutConstraint * heightConstraint;

@property (nonatomic) CGFloat singleLineHeight;
@property (nonatomic) NSSize inset;
@property (nonatomic) CGFloat minimumHeight;
@property (nonatomic) NSSize padding;

@end

@implementation TKOResizingTextView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    [self setDefaultFont];
    [self configure];
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    [self setDefaultFont];
    [self configure];
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect textContainer:(NSTextContainer *)container
{
    self = [super initWithFrame:frameRect textContainer:container];
    [self setDefaultFont];
    [self configure];
    return self;
}

- (void)setDefaultFont
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSFont * font = [NSFont fontWithName:[defaults stringForKey:@"TKOApplicationTextViewFontName"]
                                    size:[defaults floatForKey:@"TKOApplicationTextViewFontSize"]];
    self.font = font;
}

- (void)setFont:(NSFont *)font
{
    if (!font) {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        return;
    }
    [super setFont:font];
    [self configure];
}

- (void)setFont:(NSFont *)font range:(NSRange)range
{
    if (!font) {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        return;
    }
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
    if (!self.wantsLayer) {
        self.wantsLayer = YES;
        self.layer.borderColor = [[NSColor gridColor] CGColor];
        self.layer.cornerRadius = 5.0;
        self.layer.borderWidth = self.shouldOutlineBorder ? 1.0 : 0.0;
    }

    self.allowsUndo = YES;
    
    NSFont * font = self.font;
    
    self.singleLineHeight   = ceilf(font.ascender + fabsf(font.descender));
    
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
//        _heightConstraint.priority = NSLayoutPriorityFittingSizeCompression - 20;
        [self addConstraint:_heightConstraint];
    } else {
        _heightConstraint.constant = _minimumHeight;
    }
}


- (void)viewWillDraw // Not the granularity I want: overkill? But only coarser updates are available AFAIK. They are jittery and insufficient.
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
    
    static NSColor * blueBorder;
    if (!blueBorder) {
        blueBorder = [NSColor colorWithCalibratedRed:61.0/255.0 green:152.0/255.0 blue:246.0/255.0 alpha:1.0];
    }
    
    self.layer.borderColor = [blueBorder CGColor];
    self.layer.borderWidth = 2.0;
    return YES;
}

- (BOOL)resignFirstResponder
{
    if (![super resignFirstResponder]) return NO;

    if (!self.shouldOutlineBorder) {
        self.layer.borderWidth = 0.0;
    } else {
        self.layer.borderColor = [[NSColor gridColor] CGColor];
        self.layer.borderWidth = 1.0;
    }
    return YES;
}

@end
