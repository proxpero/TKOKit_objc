//
//  NSAttributedString+TKOKit.m
//  TKOKit
//
//  Created by Todd Olsen on 12/24/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "NSAttributedString+TKOKit.h"
#import "NSColor+TKOKit.h"

@implementation NSAttributedString (TKOKit)

+ (NSAttributedString *)attributedStringWithText:(NSString *)text
                                            font:(TKO_FONT *)font
                                           color:(TKO_COLOR *)color
                                         kerning:(BOOL)kerning
{
	NSDictionary *attributes;
    
	if (kerning) {
		attributes = @{NSFontAttributeName : font, NSForegroundColorAttributeName : color, NSKernAttributeName : [NSNull null]};
	} else {
		attributes = @{NSFontAttributeName : font, NSForegroundColorAttributeName : color};
	}
    
	return [[self alloc] initWithString:text
                             attributes:attributes];
}

@end
