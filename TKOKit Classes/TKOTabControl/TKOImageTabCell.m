//
//  TKOImageTabCell.m
//  Keystone
//
//  Created by Todd Olsen on 12/12/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "TKOImageTabCell.h"

@implementation TKOImageTabCell

- (void)drawWithFrame:(NSRect)cellFrame
               inView:(NSView *)controlView
{
    [self.backgroundColor set];
    NSRectFill(cellFrame);
    
    if (self.image && self.imagePosition != NSNoImage) {
        [self drawImage:[self.image imageWithTint:(self.state|self.isHighlighted) ? self.imageHighlightColor : self.imageColor]
              withFrame:cellFrame
                 inView:controlView];
    }
    
    [self drawBordersInCellFrame:cellFrame];
}

@end
