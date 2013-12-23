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

NSString *QSStringReplaceAll(NSString *stringToSearch, NSString *searchFor, NSString *replaceWith); /*Literal search*/

@interface NSString (TKOKit)

@end
