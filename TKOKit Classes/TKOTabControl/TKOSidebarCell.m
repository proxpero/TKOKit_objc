//
//  TKOSidebarCell.m
//  TKOSidebarDemo
//
//  Created by Todd Olsen on 4/8/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOSidebarCell.h"
#import "NSColor+TKOKit.h"
#import "NSImage+TKOKit.h"

@implementation TKOSidebarCell

- (void)setDefaultColors
{
    [super setDefaultColors];
    self.textColor                  = [NSColor colorWithHexString:@"444444"];
    self.textHighlightColor         = [NSColor colorWithHexString:@"ffffff"];
    self.imageColor                 = [NSColor colorWithHexString:@"5e5e5e"];
    self.imageHighlightColor        = [NSColor colorWithHexString:@"0096f2"];
    
    self.highlightsBy = NSNoCellMask;
}

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

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSRect imageFrame;
    NSRect titleFrame;
    NSDivideRect(NSInsetRect(cellFrame, 1, 5), &imageFrame, &titleFrame, NSHeight(cellFrame) * 0.6, NSMinYEdge);
    
//    imageFrame = NSMakeRect(imageFrame.origin.x, imageFrame.origin.y, imageFrame.size.width, imageFrame.size.height + 10);
    
    if (self.image)
    {
        [self drawImage:[self.image imageWithTint:(self.state|self.isHighlighted) ? self.imageHighlightColor : self.imageColor] withFrame:imageFrame inView:controlView];
        if (self.imagePosition != NSImageOnly)
        {
            NSMutableAttributedString * attributedTitle = self.attributedTitle.mutableCopy;
            [attributedTitle addAttributes:@{ NSForegroundColorAttributeName : (self.state ? self.textHighlightColor : self.textColor) }
                                     range:NSMakeRange(0, attributedTitle.length)];
            [self drawTitle:attributedTitle withFrame:titleFrame inView:controlView];
        }
    }
    else if (self.title)
    {
        [self drawTitle:self.attributedTitle withFrame:NSInsetRect(titleFrame, 3, 3) inView:controlView];
    }
}


@end
