//
//  NSUserDefaults+TKOKit.m
//
//  Created by Todd Olsen on 11/30/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "NSUserDefaults+TKOKit.h"
#import "NSColor+TKOKit.h"

@implementation NSUserDefaults (TKOKit)

- (NSColor *)colorForKey:(NSString *)key
{
    NSString * stringForKey = [self stringForKey:key];
    NSColor * color = [NSColor colorWithHexString:stringForKey];
    return color;
}

@end
