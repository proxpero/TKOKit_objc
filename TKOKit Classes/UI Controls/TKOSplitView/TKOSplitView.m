//
//  TKOSplitView.m
//  TKOProblemUI
//
//  Created by Todd Olsen on 10/7/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOSplitView.h"

@implementation TKOSplitView

- (NSColor*)dividerColor
{
    return (self.customDividerColor == nil) ? [super dividerColor] : self.customDividerColor;
}

@end
