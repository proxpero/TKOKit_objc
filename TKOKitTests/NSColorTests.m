//
//  NSColorTests.m
//  TKOKit
//
//  Created by Todd Olsen on 12/23/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSColor+TKOKit.h"

@interface NSColorTests : XCTestCase
@end

static const CGFloat accuracy = 0.01f;

@implementation NSColorTests


- (void)testTKOColorWithHexString {
    
	NSColor * color;
    
    color = [NSColor colorWithHexString:@"000000"];
	CGFloat red, green, blue, alpha;
	[color getRed:&red
            green:&green
             blue:&blue
            alpha:&alpha];
    
	XCTAssertEqualWithAccuracy(red, 0.0f, accuracy);
	XCTAssertEqualWithAccuracy(green, 0.0f, accuracy);
	XCTAssertEqualWithAccuracy(blue, 0.0f, accuracy);
	XCTAssertEqualWithAccuracy(alpha, 1.0f, accuracy);

    color = [NSColor colorWithHexString:@"#000000"];
	[color getRed:&red
            green:&green
             blue:&blue
            alpha:&alpha];
    
	XCTAssertEqualWithAccuracy(red, 0.0f, accuracy);
	XCTAssertEqualWithAccuracy(green, 0.0f, accuracy);
	XCTAssertEqualWithAccuracy(blue, 0.0f, accuracy);
	XCTAssertEqualWithAccuracy(alpha, 1.0f, accuracy);
    
    
	color = [NSColor colorWithHexString:@"FFFFFF"];
	[color getRed:&red
            green:&green
             blue:&blue
            alpha:&alpha];
    
	XCTAssertEqualWithAccuracy(red, 1.0f, accuracy);
	XCTAssertEqualWithAccuracy(green, 1.0f, accuracy);
	XCTAssertEqualWithAccuracy(blue, 1.0f, accuracy);
	XCTAssertEqualWithAccuracy(alpha, 1.0f, accuracy);
    
	color = [NSColor colorWithHexString:@"FF000000"];
	[color getRed:&red
            green:&green
             blue:&blue
            alpha:&alpha];
    
	XCTAssertEqualWithAccuracy(red, 1.0f, accuracy);
	XCTAssertEqualWithAccuracy(green, 0.0f, accuracy);
	XCTAssertEqualWithAccuracy(blue, 0.0f, accuracy);
	XCTAssertEqualWithAccuracy(alpha, 0.0f, accuracy);
    
	color = [NSColor colorWithHexString:@"7F7f7F7F"];
	[color getRed:&red
            green:&green
             blue:&blue
            alpha:&alpha];
    
	XCTAssertEqualWithAccuracy(red, 0.5f, accuracy);
	XCTAssertEqualWithAccuracy(green, 0.5f, accuracy);
	XCTAssertEqualWithAccuracy(blue, 0.5f, accuracy);
	XCTAssertEqualWithAccuracy(alpha, 0.5f, accuracy);
}

@end
