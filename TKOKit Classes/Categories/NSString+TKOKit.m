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


NSString * TKOBinaryStringFromInteger(NSInteger number)
{
    NSMutableString * string = [NSMutableString new];
    NSInteger spacing = pow(2, 3);
    NSInteger width = (sizeof(number)) * spacing;
    NSInteger binaryDigit = 0;
    NSInteger integer = number;
    
    while (binaryDigit < width) {
        binaryDigit++;
        [string insertString:(integer & 1) ? @"1" : @"0"
                     atIndex:0];
        
        if (binaryDigit % spacing == 0 && binaryDigit != width) {
            [string insertString:@" "
                         atIndex:0];
        }
        integer = integer >> 1;
    }
    return string;
}


@implementation NSString (TKOKit)




- (BOOL)containsString:(NSString *)substring
{
    return ([self rangeOfString:substring].location != NSNotFound);
}


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

- (NSAttributedString *)attributedStringFromMarkdown
{
    NSMutableString * markdown = self.mutableCopy;
    
    NSRange limitedRange = NSMakeRange(0, markdown.length);
    NSRange range = [markdown rangeOfString:@"/" options:0 range:limitedRange];
    NSInteger open  = NSNotFound;
    NSInteger close = NSNotFound;
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:markdown];
    
    NSFont * systemFont = [NSFont systemFontOfSize:[NSFont systemFontSize]];
    NSFont * italic = [[NSFontManager sharedFontManager] convertFont:systemFont toHaveTrait:NSFontItalicTrait];
    NSFont * bold = [NSFont boldSystemFontOfSize:[NSFont systemFontSize]];
    
    NSMutableArray * italicRanges = [NSMutableArray new];
    
    while (range.location != NSNotFound) {
        if (open == NSNotFound) {
            open = range.location;
            limitedRange = NSMakeRange(open + 1, markdown.length - open - 1);
        } else if (close == NSNotFound) {
            close = range.location;
            limitedRange= NSMakeRange(close + 1, markdown.length - close - 1);
        }
        if (open != NSNotFound && close != NSNotFound) {
            NSRange italicRange = NSMakeRange(open, close - open);
            [italicRanges addObject:[NSValue valueWithRange:italicRange]];
            open = NSNotFound;
            close = NSNotFound;
        }
        range = [markdown rangeOfString:@"/" options:0 range:limitedRange];
    }
    
    for (NSValue * value in italicRanges) {
        NSRange range = [value rangeValue];
        [attributedString addAttribute:NSFontAttributeName value:italic range:range];
    }
    
    limitedRange = NSMakeRange(0, markdown.length);
    range = [markdown rangeOfString:@"*" options:0 range:limitedRange];
    
    NSMutableArray * boldRanges = [NSMutableArray new];
    
    while (range.location != NSNotFound) {
        if (open == NSNotFound) {
            open = range.location;
            limitedRange = NSMakeRange(open + 1, markdown.length - open - 1);
        } else if (close == NSNotFound) {
            close = range.location;
            limitedRange = NSMakeRange(close + 1, markdown.length - close - 1);
        }
        if (open != NSNotFound && close != NSNotFound) {
            NSRange boldRange = NSMakeRange(open, close - open);
            [boldRanges addObject:[NSValue valueWithRange:boldRange]];
            open = NSNotFound;
            close = NSNotFound;
        }
        range = [markdown rangeOfString:@"*" options:0 range:limitedRange];
    }
    
    for (NSValue * value in boldRanges) {
        NSRange range = [value rangeValue];
        [attributedString addAttribute:NSFontAttributeName value:bold range:range];
    }
    
    [attributedString.mutableString replaceOccurrencesOfString:@"/" withString:@"" options:0 range:NSMakeRange(0, attributedString.length)];
    [attributedString.mutableString replaceOccurrencesOfString:@"*" withString:@"" options:0 range:NSMakeRange(0, attributedString.length)];
    
    return attributedString;
}


- (NSRange)rangeofSubstringWithinDelimitersOpen:(NSString *)open close:(NSString *)close
{
    NSRange openRange = [self rangeOfString:open options:NSLiteralSearch];
    NSRange closeRange = [self rangeOfString:close options:NSLiteralSearch];
    return NSMakeRange(openRange.location + openRange.length + 1, closeRange.location - (openRange.location + openRange.length));
}

- (NSArray*)csvComponents
{
    NSMutableArray* components = [NSMutableArray array];
    NSScanner* scanner = [NSScanner scannerWithString:self];
    NSString* quote = @"\"";
    NSString* separator = @",";
    NSString* result;
    while(![scanner isAtEnd]) {
        if([scanner scanString:quote intoString:NULL]) {
            [scanner scanUpToString:quote intoString:&result];
            [scanner scanString:quote intoString:NULL];
        } else {
            [scanner scanUpToString:separator intoString:&result];
        }
        [scanner scanString:separator intoString:NULL];
        if (result)
            [components addObject:result];
        else
            [components addObject:[NSNull null]];
    }
    return components;
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
