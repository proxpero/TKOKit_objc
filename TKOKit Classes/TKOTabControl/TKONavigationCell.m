//
//  TKONavigationCell.m
//  Keystone
//
//  Created by Todd Olsen on 12/14/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "TKONavigationCell.h"

@implementation TKONavigationCell

- (id)init
{
    if ( !(self = [super init]) )  return nil;
    [self sendActionOn:NSLeftMouseDownMask];

    return self;
}

- (id)initTextCell:(NSString *)aString
{
    if ( !(self = [super initTextCell:aString]) )  return nil;
    [self sendActionOn:NSLeftMouseDownMask];
    return self;
}

- (void)drawWithFrame:(NSRect)cellFrame
               inView:(NSView *)controlView
{
    [self.backgroundColor set];
    NSRectFill(cellFrame);
    
    if (self.menu && self.showsMenu) {
        [[TKONavigationCell popupImage] drawInRect:[self popupRectWithFrame:cellFrame]
                                          fromRect:NSZeroRect
                                         operation:NSCompositeSourceOver
                                          fraction:1.0
                                    respectFlipped:YES
                                             hints:nil];
    }
    [self drawBordersInCellFrame:cellFrame];
}

- (BOOL)trackMouse:(NSEvent *)theEvent
            inRect:(NSRect)cellFrame
            ofView:(NSView *)controlView
      untilMouseUp:(BOOL)flag
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSRect popupRect = [self popupRectWithFrame:cellFrame];
    NSPoint location = [controlView convertPoint:[theEvent locationInWindow]
                                        fromView:nil];
    
    if (self.menu.itemArray.count > 0 &&  NSPointInRect(location, popupRect)) {
        [self.menu popUpMenuPositioningItem:self.menu.itemArray[0]
                                 atLocation:NSMakePoint(NSMidX(popupRect), NSMaxY(popupRect))
                                     inView:controlView];
        return YES;
    } else {
        return [super trackMouse:theEvent
                          inRect:cellFrame
                          ofView:controlView
                    untilMouseUp:flag];
    }
}

@end
