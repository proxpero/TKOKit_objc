//
//  TKOControl.m
//  TKOKit
//
//  Created by Todd Olsen on 1/29/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOControl.h"
#import "TKOControlCell.h"
#import "NSColor+TKOKit.h"
#import "TKOTheme.h"

@implementation TKOControl

+ (Class)cellClass
{
    return [TKOControlCell class];
}

#pragma mark - Drawing

- (BOOL)isOpaque
{
    return YES;
}

- (BOOL)isFlipped
{
    return YES;
}

@end
