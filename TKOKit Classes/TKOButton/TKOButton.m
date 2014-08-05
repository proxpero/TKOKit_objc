//
//  TKOButton.m
//  TKOSegmentedControlDemo
//
//  Created by Todd Olsen on 6/28/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOButton.h"

@interface TKOButton ()

@end

@implementation TKOButton

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self == nil) return nil;
    
    self.translatesAutoresizingMaskIntoConstraints = NO;

    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    NSMutableAttributedString * attrStr;
    
    if (self.state == 0) {

        attrStr = self.attributedTitle.mutableCopy;
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:self.textColor
                        range:NSMakeRange(0, attrStr.length)];
        self.attributedTitle = attrStr;
        [self.attributedTitle drawInRect:NSOffsetRect(self.bounds, 0, 5)];
        NSRect slice, rem;
        NSDivideRect(self.bounds, &slice, &rem, 1, NSMaxYEdge);
        [self.backgroundGradient drawInRect:rem angle:90.0];


    } else {

        attrStr = self.attributedTitle.mutableCopy;
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:self.textHighlightColor
                        range:NSMakeRange(0, attrStr.length)];
        self.attributedTitle = attrStr;

        NSRect slice, rem;
        NSDivideRect(self.bounds, &slice, &rem, 1, NSMaxYEdge);

        [self.backgroundHighlightGradient drawInRect:rem angle:90.0];
    }
    [self.attributedTitle drawInRect:self.bounds];
    
    [self drawBordersInCellFrame:self.bounds];
    
}

- (void)drawBordersInCellFrame:(NSRect)cellFrame
{
    NSRect *borderRects;
    NSInteger borderRectCount;
    TKOBorderMask bm = self.state ? self.borderHighlightMask : self.borderMask;
    if (TKORectArrayWithBorderMask(cellFrame, bm, &borderRects, &borderRectCount)) {
        [(self.state ? self.borderHighlightColor : self.borderColor) set];
        NSRectFillList(borderRects, borderRectCount);
    }
}


- (void)setBorderColor:(NSColor *)borderColor
{
    if (_borderColor == borderColor) return;
    _borderColor = borderColor.copy;
    self.borderHighlightColor = [_borderColor blendedColorWithFraction:.35
                                                               ofColor:[NSColor blackColor]];
}


@end
