//
//  NSAttributedString+TKOKit.h
//  TKOKit
//
//  Created by Todd Olsen on 12/24/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKOPlatform.h"

@interface NSAttributedString (TKOKit)

/*If kerning, adds NSKernAttributeName : [NSNull null] (which is 
 the right way to turn on kerning, weirdly). Always Be Kerning.
 (Except that it breaks NSTextView's text pasteboard writing. So 
 don't do it there.)*/

+ (NSAttributedString *)attributedStringWithText:(NSString *)text
                                            font:(TKO_FONT *)font
                                           color:(TKO_COLOR *)color
                                         kerning:(BOOL)kerning;

@end
