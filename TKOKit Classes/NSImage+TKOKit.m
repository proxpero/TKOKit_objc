//
//  NSImage+TKOKit.m
//  TKOKit
//
//  Created by Todd Olsen on 12/24/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "NSImage+TKOKit.h"

@implementation NSImage (TKOKit)

- (NSImage *)imageWithTint:(NSColor *)color
{
    NSRect imageRect = NSZeroRect; imageRect.size = self.size;
    NSImage *highlightImage = [[NSImage alloc] initWithSize:imageRect.size];
    
    [highlightImage lockFocus];
    
    [self drawInRect:imageRect
            fromRect:NSZeroRect
           operation:NSCompositeSourceOver
            fraction:1.0];
    
    [color set];
    NSRectFillUsingOperation(imageRect, NSCompositeSourceAtop);
    
    [highlightImage unlockFocus];
    
    return highlightImage;
}

@end
