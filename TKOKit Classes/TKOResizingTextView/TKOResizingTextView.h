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
@property (nonatomic, strong) IBOutlet NSLayoutConstraint * heightConstraint;
@property (nonatomic, weak) NSAttributedString * directions;

@end
