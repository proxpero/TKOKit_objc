//
//  TKOAppDelegate.m
//  TKOSidebarDemo
//
//  Created by Todd Olsen on 4/7/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOAppDelegate.h"
#import "TKOSidebar.h"

@interface TKOAppDelegate ()
@property (weak) IBOutlet TKOSidebar *sidebar;



@end

@implementation TKOAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self.sidebar setTarget:self];
    [self.sidebar setAction:@selector(buttonPressedAction)];
    [self.sidebar addItemWithImage:[NSImage imageNamed:@"Students-Off"] alternateImage:[NSImage imageNamed:@"Students-On"] title:@"Students" inGravity:NSStackViewGravityTop];
    [self.sidebar addItemWithImage:[NSImage imageNamed:@"Assignments-Off"] alternateImage:nil title:@"Assignments" inGravity:NSStackViewGravityTop];
    [self.sidebar addItemWithImage:[NSImage imageNamed:@"Problems-Off"] alternateImage:nil title:@"Problems" inGravity:NSStackViewGravityTop];
    [self.sidebar addItemWithImage:[NSImage imageNamed:@"Lists-Off"] alternateImage:nil title:@"Lists" inGravity:NSStackViewGravityTop];
    [self.sidebar addItemWithImage:[NSImage imageNamed:@"Formats-Off"] alternateImage:nil title:@"Formats" inGravity:NSStackViewGravityTop];

    [self.sidebar addItemWithImage:[NSImage imageNamed:NSImageNameTrashEmpty] alternateImage:[NSImage imageNamed:NSImageNameTrashFull] title:@"Trash" inGravity:NSStackViewGravityBottom];
}

- (void)buttonPressedAction
{
    NSLog(@"Button pressed");
}

@end
