//
//  NSView+TKOKit.h
//  TKOKit
//
//  Created by Todd Olsen on 12/23/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSView (TKOKit)

+ (id)viewForClass:(Class)clss;

- (void)addFullSizeConstraintsForSubview:(NSView *)view;

@end
