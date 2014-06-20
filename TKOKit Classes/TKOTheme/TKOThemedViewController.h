//
//  TKOThemedViewController.h
//  TKOTabViewDemo
//
//  Created by Todd Olsen on 6/19/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TKOTheme;
@interface TKOThemedViewController : NSViewController
@property (nonatomic, readonly) TKOTheme * theme;
@end
