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

+ (instancetype)colorWithString:(NSString *)string
{
    NSColor * color = nil;
    
    if ([string isEqualToString:@"textColor"])              color = [NSColor textColor];
    else if ([string isEqualToString:@"controlColor"])      color = [NSColor controlColor];
    else if ([string isEqualToString:@"grayColor"])         color = [NSColor grayColor];
    else if ([string isEqualToString:@"darkGrayColor"])     color = [NSColor darkGrayColor];
    else if ([string isEqualToString:@"lightGrayColor"])    color = [NSColor lightGrayColor];
    else if ([string isEqualToString:@"gridColor"])         color = [NSColor gridColor];
    else if ([string isEqualToString:@"labelColor"])        color = [NSColor labelColor];
    else                                                    color = [self colorWithHexString:string];
    
    return color;
}

+ (instancetype)colorWithHexString:(NSString *)hexString
{
	TKORGBAComponents components = [hexString rgbaComponents];
    
    return [NSColor colorWithCalibratedRed:components.red
                                     green:components.green
                                      blue:components.blue
                                     alpha:components.alpha];
}


@end
