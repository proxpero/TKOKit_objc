//
//  TKOHeaderCell.m
//  Keystone
//
//  Created by Todd Olsen on 12/2/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "TKOHeaderCell.h"
#import "TKOTabControl.h"
#import "NSColor+TKOKit.h"
#define TKOPullDownTemplate @"TKOPullDownTemplate"

@implementation TKOHeaderCell

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    [self setDefaultColors];
    self.target = nil;
    self.action = NULL;
    self.title = @"";
    self.borderMask = TKOBorderMaskBottom;

    return self;
}

- (id)initTextCell:(NSString *)aString {
    self = [super initTextCell:aString];
    if (!self)
        return nil;
    
    [self setImagePosition:NSNoImage];
    [self setDefaultColors];

    return self;
}

- (id)initImageCell:(NSImage *)image
{
    self = [super initImageCell:image];
    if (!self)
        return nil;

    [self setImagePosition:NSImageOnly];
    [self setDefaultColors];

    return self;
}

- (void)setShowsMenu:(BOOL)showsMenu {
    if (_showsMenu != showsMenu) {
        _showsMenu = showsMenu;
        
        [self.controlView setNeedsDisplay:YES];
    }
}

- (void)setDefaultColors
{
    self.backgroundColor            = [NSColor colorWithHexString:@"ededed"];
    self.backgroundHighlightColor   = [NSColor colorWithHexString:@"0096f2"];
    self.borderColor                = [NSColor colorWithHexString:@"b3b3b3"];
    self.borderHighlightColor       = [NSColor colorWithHexString:@"0070c4"];
    self.textColor                  = [NSColor colorWithHexString:@"444444"];
    self.textHighlightColor         = [NSColor colorWithHexString:@"ffffff"];
    self.imageColor                 = [NSColor colorWithHexString:@"5e5e5e"];
    self.imageHighlightColor        = [NSColor colorWithHexString:@"0096f2"];
    
    [self setBordered:NO];
    [self setHighlightsBy:NSNoCellMask];
}


//- (void)setBackgroundColor:(NSColor *)backgroundColor
//{
//    if (_backgroundColor != backgroundColor) {
//        _backgroundColor = backgroundColor.copy;
//        
//        [self.controlView setNeedsDisplay:YES];
//    }
//}


//- (void)setBackgroundHighlightColor:(NSColor *)backgroundHighlightColor {
//    if (_backgroundHighlightColor != backgroundHighlightColor) {
//        _backgroundHighlightColor = backgroundHighlightColor.copy;
//        [self.controlView setNeedsDisplay:YES];
//    }
//}


//- (void)setBorderColor:(NSColor *)borderColor
//{
//    if (_borderColor != borderColor) {
//        _borderColor = borderColor.copy;
//        
//        [self.controlView setNeedsDisplay:YES];
//    }
//}


//- (void)setBorderHighlightColor:(NSColor *)borderHighlightColor {
//    if (_borderHighlightColor != borderHighlightColor) {
//        _borderHighlightColor = borderHighlightColor.copy;
//        [self.controlView setNeedsDisplay:YES];
//    }
//}


- (void)setTextColor:(NSColor *)textColor {
    if (_textColor != textColor) {
        _textColor = textColor.copy;
        [self.controlView setNeedsDisplay:YES];
    }
}


- (void)setTextHighlightColor:(NSColor *)textHighlightColor {
    if (_textHighlightColor != textHighlightColor) {
        _textHighlightColor = textHighlightColor.copy;
        [self.controlView setNeedsDisplay:YES];
    }
}


- (void)setImageColor:(NSColor *)imageColor {
    if (_imageColor != imageColor) {
        _imageColor = imageColor.copy;
        [self.controlView setNeedsDisplay:YES];
    }
}


- (void)setImageHighlightColor:(NSColor *)imageHighlightColor {
    if (_imageHighlightColor != imageHighlightColor) {
        _imageHighlightColor = imageHighlightColor.copy;
        [self.controlView setNeedsDisplay:YES];
    }
}

//- (void)setBorderMask:(TKOBorderMask)borderMask {
//    if (_borderMask != borderMask) {
//        _borderMask = borderMask;
//        [self.controlView setNeedsDisplay:YES];
//    }
//}

+ (NSImage *)popupImage {
    static NSImage *ret = nil;
    if (ret == nil) {
        ret = [[NSImage imageNamed:TKOPullDownTemplate] imageWithTint:[NSColor darkGrayColor]];
    }
    return ret;
}

- (NSRect)popupRectWithFrame:(NSRect)cellFrame
{
    NSRect popupRect = NSZeroRect;
    popupRect.size = [[TKOHeaderCell popupImage] size];
    popupRect.origin = NSMakePoint(NSMaxX(cellFrame) - NSWidth(popupRect) - 8, NSMidY(cellFrame) - NSHeight(popupRect) / 2);
    
    return popupRect;
}

- (void)drawWithFrame:(NSRect)cellFrame
               inView:(NSView *)controlView
{
    [((self.state|self.isHighlighted) ? self.backgroundHighlightColor : self.backgroundColor) set];
    NSRectFill(cellFrame);
    
    if (self.menu && self.showsMenu) {
        [[TKOHeaderCell popupImage] drawInRect:[self popupRectWithFrame:cellFrame]
                                          fromRect:NSZeroRect
                                         operation:NSCompositeSourceOver
                                          fraction:1.0
                                    respectFlipped:YES
                                             hints:nil];
    }
    
    if (self.image && self.imagePosition != NSNoImage) {
        [self drawImage:[self.image imageWithTint:(self.state|self.isHighlighted) ? self.imageHighlightColor : self.imageColor]
              withFrame:cellFrame
                 inView:controlView];
    }
    
    if (self.title.length && self.imagePosition != NSImageOnly) {
        NSMutableAttributedString *attributedTitle = self.attributedTitle.mutableCopy;
        [attributedTitle addAttributes:@{ NSForegroundColorAttributeName : (self.state ? self.textHighlightColor : self.textColor) }
                                 range:NSMakeRange(0, attributedTitle.length)];
        [self drawTitle:attributedTitle
              withFrame:NSOffsetRect(cellFrame, 0, -2)
                 inView:controlView];
    }
    
    [self drawBordersInCellFrame:cellFrame];
    
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

//BOOL TKORectArrayWithBorderMask(NSRect sourceRect, TKOBorderMask borderMask, NSRect **rectArray, NSInteger *rectCount)
//{
//    NSInteger outputCount = 0;
//    static NSRect outputArray[4];
//    
//    NSRect remainderRect;
//    if (borderMask & TKOBorderMaskTop) {
//        NSDivideRect(sourceRect, &outputArray[outputCount++], &remainderRect, 1, NSMinYEdge);
//    }
//    if (borderMask & TKOBorderMaskLeft) {
//        NSDivideRect(sourceRect, &outputArray[outputCount++], &remainderRect, 1, NSMinXEdge);
//    }
//    if (borderMask & TKOBorderMaskRight) {
//        NSDivideRect(sourceRect, &outputArray[outputCount++], &remainderRect, 1, NSMaxXEdge);
//    }
//    if (borderMask & TKOBorderMaskBottom) {
//        NSDivideRect(sourceRect, &outputArray[outputCount++], &remainderRect, 1, NSMaxYEdge);
//    }
//    
//    if (rectCount) *rectCount = outputCount;
//    if (rectArray) *rectArray = &outputArray[0];
//    
//    return (outputCount > 0);
//}
