//
//  NSView+TKOKit.m
//  TKOKit
//
//  Created by Todd Olsen on 12/23/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "NSView+TKOKit.h"

@implementation NSView (TKOKit)


+ (id)viewWithClass:(Class)clss
{
    NSView * view = [[clss alloc] initWithFrame:NSZeroRect];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    return view;
}


- (void)addFullSizeConstraintsForSubview:(NSView *)view
{
	NSDictionary * views = NSDictionaryOfVariableBindings(view);
	NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[view]|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:views];
	[self addConstraints:constraints];
    
	constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                          options:0
                                                          metrics:nil
                                                            views:views];
    [self addConstraints:constraints];
}

@end
