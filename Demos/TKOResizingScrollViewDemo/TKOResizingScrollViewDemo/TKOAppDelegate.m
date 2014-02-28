//
//  TKOAppDelegate.m
//  TKOResizingScrollViewDemo
//
//  Created by Todd Olsen on 2/28/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOAppDelegate.h"
#import "TKOTableViewDelegate.h"

@implementation TKOAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self.tableViewDelegate setVisibleRows:12]; // Arbitrary maximum visible rows
    [self.tableViewDelegate setRows:3];         // Arbitrary initial number of rows
}

@end
