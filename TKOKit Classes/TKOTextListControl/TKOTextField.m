//
//  TKOTextField.m
//  ProblemEditor
//
//  Created by Todd Olsen on 5/30/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOTextField.h"

@implementation TKOTextField

-(NSSize)intrinsicContentSize
{
    // http://stackoverflow.com/a/10463761/277905
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if ( ![self.cell wraps] ) {
        return [super intrinsicContentSize];
    }
    
    NSRect frame = [self frame];
    
    CGFloat width = frame.size.width;
    
    // Make the frame very high, while keeping the width
    frame.size.height = CGFLOAT_MAX;
    
    // Calculate new height within the frame
    // with practically infinite height.
    CGFloat height = [self.cell cellSizeForBounds: frame].height;
    
    return NSMakeSize(width, height);
}

@end
