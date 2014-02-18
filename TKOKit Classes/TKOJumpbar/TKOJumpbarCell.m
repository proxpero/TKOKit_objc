//
//  TKOJumpbarCell.m
//  Keystone
//
//  Created by Todd Olsen on 12/29/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "TKOJumpbarCell.h"

@implementation TKOJumpbarCell

- (NSRect)iconRectWithFrame:(NSRect)cellFrame
{
    NSRect iconRect = NSZeroRect;
    iconRect.size = [[self icon] size];
    iconRect.origin = NSMakePoint(NSMaxX(cellFrame) - NSWidth(iconRect) - 1, NSMidY(iconRect) - NSHeight(iconRect) / 2);
    
    return iconRect;
}

- (void)drawWithFrame:(NSRect)cellFrame
               inView:(NSView *)controlView
{
    [(self.isLast ? self.backgroundHighlightColor : self.backgroundColor) set];
    NSRectFill(cellFrame);

    NSMutableAttributedString * attributedTitle = self.attributedTitle.mutableCopy;
    [attributedTitle addAttributes:@{ NSForegroundColorAttributeName : (self.isLast) ? [NSColor whiteColor] : self.textColor }
                             range:NSMakeRange(0, attributedTitle.length)];
    
    [self drawImage:[self.icon imageWithTint:self.isLast ? [NSColor whiteColor] : self.imageColor]
          withFrame:NSOffsetRect(cellFrame, 12 - NSWidth(cellFrame)/2, 0)
             inView:controlView];
    
    [self drawTitle:attributedTitle
          withFrame:NSOffsetRect(cellFrame, 4, 0)
             inView:controlView];
    
    if (!self.isLast) {
        NSImage * triangle = [[NSImage imageNamed:NSImageNameGoRightTemplate] imageWithTint:self.imageColor];
        
        NSRect triangleRect = NSZeroRect;
        triangleRect.size = [triangle size];
        triangleRect.origin = NSMakePoint(NSMaxX(cellFrame) - NSWidth(triangleRect) - 3, NSMidY(cellFrame) - NSHeight(triangleRect) / 2 + 0.5);

        [triangle drawInRect:triangleRect
                    fromRect:NSZeroRect
                   operation:NSCompositeSourceOver
                    fraction:1
              respectFlipped:YES
                       hints:nil];
    }
    
    if (self.isLast)
        [self setBorderMask:self.borderMask|TKOBorderMaskRight];
    
    [self drawBordersInCellFrame:cellFrame];
}

- (void)drawBordersInCellFrame:(NSRect)cellFrame
{
    NSRect *borderRects;
    NSInteger borderRectCount;
    if (TKORectArrayWithBorderMask(cellFrame, self.borderMask, &borderRects, &borderRectCount)) {
        [(self.isLast) ? self.borderHighlightColor : self.borderColor set];
        NSRectFillList(borderRects, borderRectCount);
    }
}

@end

