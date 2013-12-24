//
//  NSStringTests.m
//  TKOKit
//
//  Created by Todd Olsen on 12/23/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+TKOKit.h"

@interface NSStringTests : XCTestCase
@end

@implementation NSStringTests

- (void)testTKOStringIsEmpty
{
    XCTAssertTrue(TKOStringIsEmpty(nil));
    XCTAssertTrue(TKOStringIsEmpty(@""));
    
    XCTAssertFalse(TKOStringIsEmpty(@" "));
    XCTAssertFalse(TKOStringIsEmpty(@"Foo"));
}


- (void)testTKOEqualStrings
{
	NSString *s1 = nil;
	NSString *s2 = nil;
    
	XCTAssertTrue(TKOEqualStrings(s1, s2));
    
	s2 = @"Foo";
	XCTAssertFalse(TKOEqualStrings(s1, s2));
    
	s1 = @"Bar";
	s2 = nil;
	XCTAssertFalse(TKOEqualStrings(s1, s2));
    
	s1 = @"x";
	s2 = @"y";
	XCTAssertFalse(TKOEqualStrings(s1, s2));
    
	s1 = @"";
	s2 = @"";
	XCTAssertTrue(TKOEqualStrings(s1, s2));
    
	s1 = @"I am un chien";
	s2 = @"Andalusia";
	XCTAssertFalse(TKOEqualStrings(s1, s2));
}


- (void)testTKOStringReplaceAll
{
	NSString *s = @"where is my cat";
	s = TKOStringReplaceAll(s, @"cat", @"mind");
	XCTAssertEqualObjects(s, @"where is my mind");
    
	s = TKOStringReplaceAll(s, @"dog", @"foo");
	XCTAssertEqualObjects(s, @"where is my mind");
    
	XCTAssertNotNil(TKOStringReplaceAll(@"", @"foo", @"bar"));
	XCTAssertNil(TKOStringReplaceAll(nil, @"foo", @"bar"));
}


- (void)testStringByTrimmingWhitespace
{
	NSString *s = @"   ";
	XCTAssertTrue([[s stringByTrimmingWhitespace] isEqualToString:@""]);
    
	s = @"   x   ";
	XCTAssertTrue([[s stringByTrimmingWhitespace] isEqualToString:@"x"]);
    
	s = @"Foo";
	XCTAssertTrue([[s stringByTrimmingWhitespace] isEqualToString:@"Foo"]);
}


- (void)testStringByTrimmingWhitespaceAndNewLineCharacters
{
	NSString *s = @"   ";
	XCTAssertTrue([[s stringByTrimmingWhitespaceAndNewLineCharacters] isEqualToString:@""]);
    
	s = @" \t\r\n \n  ";
	XCTAssertTrue([[s stringByTrimmingWhitespaceAndNewLineCharacters] isEqualToString:@""]);
    
	s = @"   x   ";
	XCTAssertTrue([[s stringByTrimmingWhitespaceAndNewLineCharacters] isEqualToString:@"x"]);
    
	s = @"  x\t  \ny foo\r";
	XCTAssertTrue([[s stringByTrimmingWhitespaceAndNewLineCharacters] isEqualToString:@"x\t  \ny foo"]);
    
	s = @"Foo";
	XCTAssertTrue([[s stringByTrimmingWhitespaceAndNewLineCharacters] isEqualToString:@"Foo"]);
}


- (void)testStringByStrippingPrefix
{
	NSString *s = @"Foobar";
    
	XCTAssertEqualObjects([s stringByStrippingPrefix:@"Foo" caseSensitive:YES], @"bar");
	XCTAssertEqualObjects([s stringByStrippingPrefix:@"foo" caseSensitive:YES], @"Foobar");
	XCTAssertEqualObjects([s stringByStrippingPrefix:@"foo" caseSensitive:NO],  @"bar");
	XCTAssertEqualObjects([s stringByStrippingPrefix:@"Foo" caseSensitive:NO],  @"bar");
	XCTAssertEqualObjects([s stringByStrippingPrefix:@"bar" caseSensitive:YES], @"Foobar");
	XCTAssertEqualObjects([s stringByStrippingPrefix:@"bar" caseSensitive:NO],  @"Foobar");
}


@end
