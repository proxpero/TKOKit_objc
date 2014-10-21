//
//  TKOTableCellView.m
//  TKOProblemUI
//
//  Created by Todd Olsen on 10/14/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOTableCellView.h"

@interface TKOTableCellView ()

@property (nonatomic) NSTrackingArea * trackingArea;
@property (nonatomic) BOOL mouseInside;

@end

@implementation TKOTableCellView

- (void)setObjectValue:(id)objectValue
{
    [super setObjectValue:objectValue];
    [self updateTrackingAreas];
    self.mightShowViews = YES;
    self.hidingViews = [NSMutableArray new];
}

//- (void)setSelected:(BOOL)selected
//{
//    _selected = selected;
//    [self updateButtonDisplay];
//}

- (void)updateButtonDisplay
{
    BOOL display = _mouseInside && self.mightShowViews; // && self.selected;

    for (NSView * view in self.hidingViews) {
        view.hidden = !display;
    }
    [self setNeedsDisplay:YES];
}

# pragma mark - Tracking

- (void)ensureTrackingArea
{
    if (self.trackingArea == nil) {
        self.trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect
                                                         options:NSTrackingInVisibleRect | NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited
                                                           owner:self
                                                        userInfo:nil];
    }
}

- (void)updateTrackingAreas
{
    [super updateTrackingAreas];
    [self ensureTrackingArea];
    if (![[self trackingAreas] containsObject:self.trackingArea]) {
        [self addTrackingArea:self.trackingArea];
    }
}

- (void)setMouseInside:(BOOL)mouseInside
{
    if (_mouseInside == mouseInside) return;
    _mouseInside = mouseInside;
    
    [self updateButtonDisplay];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    self.mouseInside = YES;
}

- (void)mouseExited:(NSEvent *)theEvent {
    self.mouseInside = NO;
}

@end
