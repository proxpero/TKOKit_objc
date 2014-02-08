//
//  TKOTextView.h
//  TextEditor
//
//  Created by Todd Olsen on 7/17/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TKOTextStorage;

@interface TKOTextView : NSTextView

@property (strong, nonatomic) TKOTextStorage * textStorage;

@end
