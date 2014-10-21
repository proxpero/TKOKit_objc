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

- (NSString *)markdown
{
    NSMutableString * markdown = self.string.mutableCopy;
    [self enumerateAttribute:NSFontAttributeName
                     inRange:NSMakeRange(0, self.length)
                     options:NSAttributedStringEnumerationReverse
                  usingBlock:^(NSFont * font, NSRange range, BOOL *stop) {
                      
                      NSInteger symbolicTraits = font.fontDescriptor.symbolicTraits;
                      if (symbolicTraits & NSFontItalicTrait) {
                          [markdown insertString:@"/" atIndex:range.location + range.length];
                          [markdown insertString:@"/" atIndex:range.location];
                      } else if (symbolicTraits & NSFontBoldTrait) {
                          [markdown insertString:@"*" atIndex:range.location + range.length];
                          [markdown insertString:@"*" atIndex:range.location];
                      }
                  }];
    return markdown;
}

@end
