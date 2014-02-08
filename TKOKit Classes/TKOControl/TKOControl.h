//
//  TKOControl.h
//  TKOKit
//
//  Created by Todd Olsen on 1/29/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TKOTheme;

@interface TKOControl : NSControl

@property (strong, nonatomic) NSColor * selectedColor;
@property (strong, nonatomic) TKOTheme * theme;

@end

