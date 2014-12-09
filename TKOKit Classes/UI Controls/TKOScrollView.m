//
//  TKOScrollView.m
//  Keystone-Mac
//
//  Created by Todd Olsen on 12/4/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOScrollView.h"

@implementation TKOScrollView

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        [self hideScrollers];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self hideScrollers];
}


- (void)setNonScrolling:(BOOL)nonScrolling
{
    _nonScrolling = nonScrolling;
    [self hideScrollers];
}


- (void)hideScrollers
{
    // Hide the scrollers. You may want to do this if you're syncing the scrolling
    // this NSScrollView with another one.
    [self setHasHorizontalScroller:!self.nonScrolling];
    [self setHasVerticalScroller:!self.nonScrolling];
}

- (void)scrollWheel:(NSEvent *)theEvent
{
    if (self.nonScrolling) {
        [self.nextResponder scrollWheel:theEvent];
        // Do nothing: disable scrolling altogether
        return;
    }
    [super scrollWheel:theEvent];
}

@end
