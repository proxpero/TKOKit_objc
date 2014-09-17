//
//  TKOResizingTextView.h
//  TKOResizingTextViewDemo
//
//  Created by Todd Olsen on 7/10/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TKOTheme;

@interface TKOResizingTextView : NSTextView

@property (nonatomic) TKOTheme * theme;
@property (nonatomic, strong) NSLayoutConstraint * heightConstraint;
@property (nonatomic, copy) NSAttributedString * placeholder;
@property (nonatomic, setter = setCollapsed:) BOOL isCollapsed;

- (instancetype)initWithTheme:(TKOTheme *)theme;

@end
