//
//  NSColor+TKOKit.m
//  TKOKit
//
//  Created by Todd Olsen on 12/23/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "NSColor+TKOKit.h"
#import "NSString+TKOKit.h"

@implementation NSColor (TKOKit)


+ (instancetype)colorWithHexString:(NSString *)hexString
{
	TKORGBAComponents components = [hexString rgbaComponents];
    
    return [NSColor colorWithCalibratedRed:components.red
                                     green:components.green
                                      blue:components.blue
                                     alpha:components.alpha];
}


@end
