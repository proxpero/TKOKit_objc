//
//  NSString+TKOKit.m
//  TKOKit
//
//  Created by Todd Olsen on 12/23/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "NSString+TKOKit.h"

NSArray * TKOComponentsBySplittingOnWhitespaceWithString(NSString * string) {
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSArray *components = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
    
    return components;
}

BOOL TKOStringIsEmpty(NSString *s) {
    
	if (s == nil || (id)s == [NSNull null]) {
		return YES;
	}
	
	return [s length] < 1;
}


BOOL TKOEqualStrings(NSString *s1, NSString *s2) {
    
	return (s1 == nil && s2 == nil) || [s1 isEqualToString:s2];
}


NSString * TKOStringReplaceAll(NSString * stringToSearch, NSString * searchFor, NSString * replaceWith) {
    
	if (TKOStringIsEmpty(stringToSearch)) {
		return stringToSearch;
	}
	if (searchFor == nil || replaceWith == nil) {
		return stringToSearch;
	}
    
	NSMutableString *s = [stringToSearch mutableCopy];
    
	[s replaceOccurrencesOfString:searchFor
                       withString:replaceWith
                          options:NSLiteralSearch
                            range:NSMakeRange(0, [s length])];
    
	return s;
}


@implementation NSString (TKOKit)


- (NSString *)stringWithCollapsedWhitespace
{
	NSMutableString *dest = [self mutableCopy];
    
	CFStringTrimWhitespace((__bridge CFMutableStringRef)dest);
    
	[dest replaceOccurrencesOfString:@"\t"
                          withString:@" "
                             options:NSLiteralSearch
                               range:NSMakeRange(0, [dest length])];
    
	[dest replaceOccurrencesOfString:@"\r"
                          withString:@" "
                             options:NSLiteralSearch
                               range:NSMakeRange(0, [dest length])];
    
	[dest replaceOccurrencesOfString:@"\n"
                          withString:@" "
                             options:NSLiteralSearch
                               range:NSMakeRange(0, [dest length])];
    
	while ([dest rangeOfString:@"  " options:0].location != NSNotFound) {
		[dest replaceOccurrencesOfString:@"  "
                              withString:@" "
                                 options:NSLiteralSearch
                                   range:NSMakeRange(0, [dest length])];
	}
    
	return dest;
}


- (NSString *)stringByTrimmingWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}


- (NSString *)stringByTrimmingWhitespaceAndNewLineCharacters
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


- (NSString *)stringByStrippingPrefix:(NSString *)prefix
                        caseSensitive:(BOOL)caseSensitive
{
	if (TKOStringIsEmpty(prefix)) {
		return self;
	}
	
    if (!caseSensitive) {
        if (![[self lowercaseString] hasPrefix:[prefix lowercaseString]])
            return self;
    } else if (![self hasPrefix:prefix]) {
        return self;
	}
    
    if ([self isEqualToString:prefix]) {
        return @"";
	}
    if (!caseSensitive && [self caseInsensitiveCompare:prefix] == NSOrderedSame) {
        return @"";
	}
    
    return [self substringFromIndex:[prefix length]];
}


- (TKORGBAComponents)rgbaComponents
{
	TKORGBAComponents components = {0.0f, 0.0f, 0.0f, 1.0f};
    
	NSMutableString * s = [self mutableCopy];
	[s replaceOccurrencesOfString:@"#"
                       withString:@""
                          options:NSLiteralSearch
                            range:NSMakeRange(0, [s length])];
	CFStringTrimWhitespace((__bridge CFMutableStringRef)s);
    
	unsigned int red = 0, green = 0, blue = 0, alpha = 0;
    
	if ([s length] >= 2) {
		if ([[NSScanner scannerWithString:[s substringWithRange:NSMakeRange(0, 2)]] scanHexInt:&red]) {
			components.red = (CGFloat)red / 255.0f;
		}
	}
    
	if ([s length] >= 4) {
		if ([[NSScanner scannerWithString:[s substringWithRange:NSMakeRange(2, 2)]] scanHexInt:&green]) {
			components.green = (CGFloat)green / 255.0f;
		}
	}
    
	if ([s length] >= 6) {
		if ([[NSScanner scannerWithString:[s substringWithRange:NSMakeRange(4, 2)]] scanHexInt:&blue]) {
			components.blue = (CGFloat)blue / 255.0f;
		}
	}
    
	if ([s length] >= 8) {
		if ([[NSScanner scannerWithString:[s substringWithRange:NSMakeRange(6, 2)]] scanHexInt:&alpha]) {
			components.alpha = (CGFloat)alpha / 255.0f;
		}
	}
    
	return components;
}


@end
