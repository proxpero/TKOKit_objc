//
//  TKOControlCell.m
//  TKOKit
//
//  Created by Todd Olsen on 1/29/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOControlCell.h"

@implementation TKOControlCell

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    [self setBordered:NO];
    [self setDefaultColors];
    self.borderMask = TKOBorderMaskBottom;
    
    return self;
}

- (void)setDefaultColors
{
    self.backgroundColor            = [NSColor colorWithHexString:@"ededed"];
    self.backgroundHighlightColor   = [NSColor colorWithHexString:@"0096f2"];
    self.borderColor                = [NSColor colorWithHexString:@"b3b3b3"];
    self.borderHighlightColor       = [NSColor colorWithHexString:@"0070c4"];
    
    [self setBordered:NO];
}

- (void)setBackgroundColor:(NSColor *)backgroundColor
{
    if (_backgroundColor != backgroundColor) {
        _backgroundColor = backgroundColor.copy;
        if (_hasAdaptiveBorderColor) {
            _borderColor = [_backgroundColor blendedColorWithFraction:.30
                                                              ofColor:[NSColor blackColor]];
        }
        [self.controlView setNeedsDisplay:YES];
    }
}

- (void)setBackgroundHighlightColor:(NSColor *)backgroundHighlightColor {
    if (_backgroundHighlightColor != backgroundHighlightColor) {
        _backgroundHighlightColor = backgroundHighlightColor.copy;
        [self.controlView setNeedsDisplay:YES];
    }
}

- (void)setBorderColor:(NSColor *)borderColor
{
    if (_borderColor != borderColor) {
        _borderColor = borderColor.copy;
        [self.controlView setNeedsDisplay:YES];
    }
}

- (void)setBorderHighlightColor:(NSColor *)borderHighlightColor {
    if (_borderHighlightColor != borderHighlightColor) {
        _borderHighlightColor = borderHighlightColor.copy;
        [self.controlView setNeedsDisplay:YES];
    }
}

- (void)drawWithFrame:(NSRect)cellFrame
               inView:(NSView *)controlView
{
    [((self.state|self.isHighlighted) ? self.backgroundHighlightColor : self.backgroundColor) set];
    NSRectFill(cellFrame);
    
    [self drawBordersInCellFrame:cellFrame];
    [self drawInteriorWithFrame:cellFrame
                         inView:controlView];
}

- (void)drawBordersInCellFrame:(NSRect)cellFrame
{
    NSRect *borderRects;
    NSInteger borderRectCount;
    if (TKORectArrayWithBorderMask(cellFrame, self.borderMask, &borderRects, &borderRectCount)) {
        [((self.state|self.isHighlighted) ? self.borderHighlightColor : self.borderColor) set];
        NSRectFillList(borderRects, borderRectCount);
    }
}

@end

BOOL TKORectArrayWithBorderMask(NSRect sourceRect, TKOBorderMask borderMask, NSRect **rectArray, NSInteger *rectCount)
{
    NSInteger outputCount = 0;
    static NSRect outputArray[4];
    
    NSRect remainderRect;
    if (borderMask & TKOBorderMaskTop) {
        NSDivideRect(sourceRect, &outputArray[outputCount++], &remainderRect, 1, NSMinYEdge);
    }
    if (borderMask & TKOBorderMaskLeft) {
        NSDivideRect(sourceRect, &outputArray[outputCount++], &remainderRect, 1, NSMinXEdge);
    }
    if (borderMask & TKOBorderMaskRight) {
        NSDivideRect(sourceRect, &outputArray[outputCount++], &remainderRect, 1, NSMaxXEdge);
    }
    if (borderMask & TKOBorderMaskBottom) {
        NSDivideRect(sourceRect, &outputArray[outputCount++], &remainderRect, 1, NSMaxYEdge);
    }
    
    if (rectCount) *rectCount = outputCount;
    if (rectArray) *rectArray = &outputArray[0];
    
    return (outputCount > 0);
}