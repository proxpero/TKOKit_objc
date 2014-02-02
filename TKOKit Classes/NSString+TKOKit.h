//
//  NSString+TKOKit.h
//  TKOKit
//
//  Created by Todd Olsen on 12/23/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>

NSArray * TKOComponentsBySplittingOnWhitespaceWithString(NSString *string);

BOOL TKOStringIsEmpty(NSString *s); /*Yes if null, NSNull, or length < 1*/
BOOL TKOEqualStrings(NSString *s1, NSString *s2); /*Equal if both are nil*/

NSString *TKOStringReplaceAll(NSString *stringToSearch, NSString *searchFor, NSString *replaceWith); /*Literal search*/

@interface NSString (TKOKit)

- (NSString *)stringWithCollapsedWhitespace;
- (NSString *)stringByTrimmingWhitespace;
- (NSString *)stringByTrimmingWhitespaceAndNewLineCharacters;
- (NSString *)stringByStrippingPrefix:(NSString *)prefix
                        caseSensitive:(BOOL)caseSensitive;
//- (NSString *)hexWithColor:(NSColor *)color;

/*0.0f to 1.0f for each.*/

typedef struct {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
} TKORGBAComponents;

/*red, green, blue components default to 1.0 if not specified.
 alpha defaults to 1.0 if not specified.*/

- (TKORGBAComponents)rgbaComponents;

@end
