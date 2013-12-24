//
//  NSAttributedStringTests.m
//  TKOKit
//
//  Created by Todd Olsen on 12/24/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSAttributedString+TKOKit.h"

@interface NSAttributedStringTests : XCTestCase

@end

@implementation NSAttributedStringTests

- (void)testAttributedStringWithText
{
	NSString *text = @"Animals were hiding behind the rocks, except the little fish.";
	NSFont *font   = [NSFont systemFontOfSize:18.0f];
	NSColor *color = [NSColor greenColor];
    
	NSAttributedString *attributedString = [NSAttributedString attributedStringWithText:text
                                                                                   font:font
                                                                                  color:color
                                                                                kerning:YES];
	XCTAssertNotNil(attributedString);
	NSDictionary *attributes = [attributedString attributesAtIndex:0
                                                    effectiveRange:nil];
	id kernAttribute = attributes[NSKernAttributeName];
	XCTAssertEqual(kernAttribute, [NSNull null]);
}

@end

