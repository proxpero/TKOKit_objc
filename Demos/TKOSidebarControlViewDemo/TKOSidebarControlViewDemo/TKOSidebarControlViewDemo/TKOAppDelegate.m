//
//  TKOAppDelegate.m
//  TKOSidebarControlViewDemo
//
//  Created by Todd Olsen on 6/29/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOAppDelegate.h"


@implementation TKOAppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.sidebar.wantsLayer = YES;
    self.sidebar.layer.backgroundColor = [[NSColor redColor] CGColor];
    
    self.sidebar.target = self;
    self.sidebar.action = @selector(testAction:);
    
    self.sidebar.items = [NSMutableArray arrayWithArray:@[
                                              [[TKOSegmentedItem alloc] initWithLabel:@"Students" image:[NSImage imageNamed:@"TKOStudentsTemplate"] tag:0],
                                              [[TKOSegmentedItem alloc] initWithLabel:@"Assignments"  image:[NSImage imageNamed:@"TKOAssignmentsTemplate"] tag:1],
                                              [[TKOSegmentedItem alloc] initWithLabel:@"Problems"  image:[NSImage imageNamed:@"TKOProblemsTemplate"] tag:2],
                                              [[TKOSegmentedItem alloc] initWithLabel:@"Lists"  image:[NSImage imageNamed:@"TKOListsTemplate"] tag:3],
                                              [[TKOSegmentedItem alloc] initWithLabel:@"Formats"  image:[NSImage imageNamed:@"TKOFormatsTemplate"] tag:4],
                                              [[TKOSegmentedItem alloc] initWithLabel:@"Tags"  image:[NSImage imageNamed:@"TKOTagsTemplate"] tag:5],
                                              [[TKOSegmentedItem alloc] initWithLabel:@"Standards"  image:[NSImage imageNamed:@"TKOStandardsTemplate"] tag:6],
                                              ]];
    [self.sidebar addConstraint:
     [NSLayoutConstraint constraintWithItem:self.sidebar
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:85]
     ];
}


- (void)testAction:(id)sender
{
    self.ta
    NSLog(@"%@ %lu %lu %s", sender, [sender selectedTag], [sender selectedIndex], __PRETTY_FUNCTION__);
}


@end
