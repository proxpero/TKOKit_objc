//
//  TKOTextTabCell.m
//  Keystone
//
//  Created by Todd Olsen on 12/12/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "TKOTextTabCell.h"

#define TKO_Highlight_Text_Color    [NSColor whiteColor]

@implementation TKOTextTabCell


- (void)drawWithFrame:(NSRect)cellFrame
               inView:(NSView *)controlView
{
    [(self.state ? self.backgroundHighlightColor : self.backgroundColor) set];
    NSRectFill(cellFrame);
    
    NSMutableAttributedString * attributedTitle = self.attributedTitle.mutableCopy;
    [attributedTitle addAttributes:@{ NSForegroundColorAttributeName : (self.state ? self.textHighlightColor : self.textColor) }
                             range:NSMakeRange(0, attributedTitle.length)];
    
    [self drawTitle:attributedTitle
          withFrame:NSOffsetRect(cellFrame, 0, 0)
             inView:controlView];
    
    
    [self drawBordersInCellFrame:cellFrame];
}

@end
