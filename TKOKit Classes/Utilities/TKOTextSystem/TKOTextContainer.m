//
//  TKOTextContainer.m
//  TextEditor
//
//  Created by Todd Olsen on 7/17/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "TKOTextContainer.h"

#define WIDTH_TRACKS        YES
#define HEIGHT_TRACKS       NO

#define CONTAINER_WIDTH     FLT_MAX
#define CONTAINER_HEIGHT    FLT_MAX

@implementation TKOTextContainer

- (id)init
{
    self = [super init];
    
    if (!self)
        return nil;
    
    [self setContainerSize:NSMakeSize(CONTAINER_WIDTH, CONTAINER_HEIGHT)];
    [self setWidthTracksTextView:WIDTH_TRACKS];
    [self setHeightTracksTextView:HEIGHT_TRACKS];
    
    return self;
}

//- (instancetype)initWithContainerSize:(NSSize)size
//{
//    self = [super initWithContainerSize:size]; if (!self) return nil;
//
//    [self setContainerSize:NSMakeSize(size.width, CONTAINER_HEIGHT)];
//    [self setWidthTracksTextView:WIDTH_TRACKS];
//    [self setHeightTracksTextView:HEIGHT_TRACKS];
//    
//    return self;
//}

@end
