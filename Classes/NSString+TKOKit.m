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


NSString * TKOStringReplaceAll(NSString *stringToSearch, NSString * searchFor, NSString * replaceWith) {
    
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

@end
