//
//  TKOAppDelegate.m
//  TKOTabViewDemo
//
//  Created by Todd Olsen on 2/17/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOAppDelegate.h"
#import "TKOTabViewController.h"
#import "NSView+TKOKit.h"

@interface TKOAppDelegate ()

@property (strong, nonatomic) TKOTabViewController * tabController;
@property (unsafe_unretained) IBOutlet NSViewController *vc1;
@property (unsafe_unretained) IBOutlet NSViewController *vc2;

@end

@implementation TKOAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.tabController = [[TKOTabViewController alloc] init];
//    [self.window.contentView addSubview:self.tabController.view];
//    [self.window.contentView addFullSizeConstraintsForSubview:self.tabController.view];
    [self.window setContentView:self.tabController.view];
    [self.tabController setTabViewControllers:@[self.vc1, self.vc2]];
}

@end
