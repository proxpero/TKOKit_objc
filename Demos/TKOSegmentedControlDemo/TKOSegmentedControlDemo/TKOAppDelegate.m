//
//  TKOAppDelegate.m
//  TKOSegmentedControlDemo
//
//  Created by Todd Olsen on 6/26/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOAppDelegate.h"
#import "TKOSegmentedControlView.h"

@implementation TKOAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.segmentedControl.target = self;
    self.segmentedControl.action = @selector(testAction:);
    
    self.segmentedControl.items = [NSMutableArray arrayWithArray:@[
                                              [[TKOSegmentedItem alloc] initWithLabel:@"Zero" image:nil tag:0],
                                              [[TKOSegmentedItem alloc] initWithLabel:@"One"  image:nil tag:1],
                                              [[TKOSegmentedItem alloc] initWithLabel:@"Two"  image:nil tag:2],
                                              ]];
    [self.segmentedControl addConstraint:
     [NSLayoutConstraint constraintWithItem:self.segmentedControl
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:28.0]
     ];
}


- (void)testAction:(id)sender
{
    NSLog(@"%@ %lu %lu %s", sender, [sender selectedTag], [sender selectedIndex], __PRETTY_FUNCTION__);
}

@end
