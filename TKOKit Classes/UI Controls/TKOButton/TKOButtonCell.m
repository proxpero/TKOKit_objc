//
//  TKOButtonCell.m
//  Keystone
//
//  Created by Todd Olsen on 12/14/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "TKOButtonCell.h"

@implementation TKOButtonCell


- (id)init
{
    self = [super init];
    if (!self) return nil;

    [self configure];

    return self;
}


- (id)initTextCell:(NSString *)aString
{
    self = [super initTextCell:aString];
    if (!self) return nil;
    
    [self configure];
    
    return self;
}


- (instancetype)initImageCell:(NSImage *)image
{
    self = [super initImageCell:image];
    if (!self) return nil;
    
    [self configure];
    
    return self;
}


- (void)configure
{
    static BOOL configured = NO; if (configured) return; configured = YES;
    
    self.bordered = NO;
    self.buttonType = NSMomentaryLightButton;
    self.title = @"";
    self.image = nil;
    self.imagePosition = NSNoImage;

    self.backgroundColor            = [NSColor colorWithHexString:@"ededed"];
    self.backgroundHighlightColor   = [NSColor colorWithHexString:@"0096f2"];
    self.borderColor                = [NSColor colorWithHexString:@"b3b3b3"];
    self.borderHighlightColor       = [NSColor colorWithHexString:@"0070c4"];
    self.textColor                  = [NSColor textColor];
    self.textHighlightColor         = [NSColor whiteColor];
    self.imageColor                 = [NSColor darkGrayColor];
    self.imageHighlightColor        = [NSColor whiteColor];
    
    self.borderMask = TKOBorderMaskBottom;
    self.borderHighlightMask = TKOBorderMaskBottom;
    
}


- (id)copyWithZone:(NSZone *)zone
{
    TKOButtonCell *copy = [super copyWithZone:zone];
    
    copy->_borderMask = _borderMask;
    copy->_borderColor = [_borderColor copyWithZone:zone];
    copy->_backgroundColor = [_backgroundColor copyWithZone:zone];
    copy->_backgroundHighlightColor = [_backgroundHighlightColor copyWithZone:zone];
    copy->_borderHighlightColor = [_borderHighlightColor copyWithZone:zone];
    
    return copy;
}


- (void)setBorderMask:(TKOBorderMask)borderMask
{
    _borderMask = borderMask;
    [self.controlView setNeedsDisplay:YES];
}


- (void)setBorderHighlightMask:(TKOBorderMask)borderHighlightMask
{
    _borderHighlightMask = borderHighlightMask;
    [self.controlView setNeedsDisplay:YES];
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


- (void)setBorderHighlightColor:(NSColor *)borderHighlightColor
{
    if (_borderHighlightColor == borderHighlightColor) return;
    _borderHighlightColor = borderHighlightColor.copy;
    [self.controlView setNeedsDisplay:YES];
}


- (void)drawWithFrame:(NSRect)cellFrame
               inView:(NSView *)controlView
{
    NSGradient * gradient = (self.state|self.isHighlighted) ? self.backgroundHighlightGradient : self.backgroundGradient;
    [gradient drawInRect:cellFrame angle:self.gradientAngle];
    
    [self drawInteriorWithFrame:cellFrame inView:controlView];
    
    [self drawBordersInCellFrame:cellFrame];

}


- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    if (self.title.length && self.imagePosition != NSImageOnly) {

        NSMutableAttributedString * attrStr = self.attributedTitle.mutableCopy;
        NSColor * color = (self.state|self.isHighlighted) ? self.textHighlightColor : self.textColor;
        [attrStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attrStr.length)];
        [self drawTitle:attrStr withFrame:NSOffsetRect(cellFrame, 0, self.verticalTextOffset) inView:controlView];
        
    }
    
    if (self.image && self.imagePosition != NSNoImage) {
        
        [self drawImage:[self.image imageWithTint:(self.isHighlighted|self.state) ? self.imageHighlightColor : self.imageColor] withFrame:NSOffsetRect(cellFrame, 0, self.verticalImageOffset) inView:controlView];
        
    }
}


- (void)drawBordersInCellFrame:(NSRect)cellFrame
{
    NSRect *borderRects;
    NSInteger borderRectCount;
    TKOBorderMask bm = (self.state|self.isHighlighted) ? self.borderHighlightMask : self.borderMask;
    if (TKORectArrayWithBorderMask(cellFrame, bm, &borderRects, &borderRectCount)) {
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

NSString * const TKOSidebarItemLabelKey     = @"TKOSidebarItemLabelKey";
NSString * const TKOSidebarItemImageKey     = @"TKOSidebarItemImageKey";
NSString * const TKOSidebarItemTagKey       = @"TKOSidebarItemTagKey";
NSString * const TKOSidebarItemGravityKey   = @"TKOSidebarItemGravityKey";

