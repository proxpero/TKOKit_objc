//
//  TKOThemedTextView.h
//  TKOThemedTextViewDemo
//
//  Created by Todd Olsen on 7/9/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TKOTheme;

@interface TKOThemedTextView : NSTextView
@property (nonatomic, strong) IBOutlet NSLayoutConstraint * heightConstraint;

- (instancetype)initWithTheme:(TKOTheme *)theme;

@end
