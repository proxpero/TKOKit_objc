//
//  NSView+TKOKit.h
//  TKOKit
//
//  Created by Todd Olsen on 12/23/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSView (TKOKit)

+ (id)viewWithClass:(Class)clss;

- (void)addSubviewWithFullSizeConstraints:(NSView *)view;
- (void)addFullSizeConstraintsForSubview:(NSView *)view;

- (void)addConstraintsForWidth:(CGFloat)width
                        height:(CGFloat)height;

+ (NSBox *)separator;

@end
