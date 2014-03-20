//
//  TKOAppDelegate.m
//  TKODifficultyInspectorViewDemo
//
//  Created by Todd Olsen on 3/19/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOAppDelegate.h"
#import "TKODifficultyInspectorViewController.h"

@implementation TKOAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.difficultyInspector = [[TKODifficultyInspectorViewController alloc] init];
    [self.stackview addView:self.difficultyInspector.view
                  inGravity:NSStackViewGravityTop];
//    [self.window setContentView:self.difficultyInspector.view];
}

@end
