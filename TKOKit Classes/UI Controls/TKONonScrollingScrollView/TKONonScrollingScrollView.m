//
//  TKONonScrollingScrollView.m
//
//  Created by Todd Olsen on 10/9/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKONonScrollingScrollView.h"

@implementation TKONonScrollingScrollView

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

- (void)hideScrollers
{
    // Hide the scrollers. You may want to do this if you're syncing the scrolling
    // this NSScrollView with another one.
    [self setHasHorizontalScroller:NO];
    [self setHasVerticalScroller:NO];
}

- (void)scrollWheel:(NSEvent *)theEvent
{
    [self.nextResponder scrollWheel:theEvent];
    // Do nothing: disable scrolling altogether
}

@end
