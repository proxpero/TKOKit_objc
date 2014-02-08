//
//  TKOTextStorage.h
//  CoreDataAttributedString
//
//  Created by Todd Olsen on 6/25/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NSString *const TKODefaultTokenName;

@class TKOTextView;

@interface TKOTextStorage : NSTextStorage

- (id)initWithTextView:(TKOTextView *)textView;

@property (nonatomic, copy) NSDictionary *tokens;

@end
