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

- (void)addSubviewWithFullSizeConstraints:(NSView *)view
{
    [self addSubview:view];
    [self addFullSizeConstraintsForSubview:view];
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

- (void)addConstraintForWidth:(CGFloat)width
{
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:self
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:width]
     ];
}

- (void)addConstraintForHeight:(CGFloat)height
{
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:self
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:height]
     ];
}

- (void)addConstraintsForWidth:(CGFloat)width
                        height:(CGFloat)height
{
    [self addConstraintForWidth:width];
    [self addConstraintForHeight:height];
}

+ (NSBox *)horizontalSeparator
{
    NSBox * separator = [NSView viewWithClass:[NSBox class]];
    separator.boxType = NSBoxSeparator;
//    [separator addConstraint:
//     [NSLayoutConstraint constraintWithItem:separator
//                                  attribute:NSLayoutAttributeHeight
//                                  relatedBy:NSLayoutRelationEqual
//                                     toItem:nil
//                                  attribute:NSLayoutAttributeNotAnAttribute
//                                 multiplier:1
//                                   constant:1]
//     ];
    return separator;
}
@end
