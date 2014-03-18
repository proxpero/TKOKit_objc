//
//  TKOAppDelegate.m
//  TKOTabViewDemo
//
//  Created by Todd Olsen on 2/17/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOAppDelegate.h"
#import "NSView+TKOKit.h"

#import "TKOTabView.h"

@interface TKOAppDelegate ()

@property (strong, nonatomic) TKOTabView * tabView;
@property (unsafe_unretained) IBOutlet NSViewController *vc1;
@property (unsafe_unretained) IBOutlet NSViewController *vc2;

@end

@implementation TKOAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{    
    self.tabView = [NSView viewWithClass:[TKOTabView class]];
    [self.window.contentView addSubviewWithFullSizeConstraints:self.tabView];
    [self.tabView setTabViewItems:@[
                                    [TKOTabViewItem itemWithView:self.vc1.view
                                                           title:self.vc1.title],
                                    [TKOTabViewItem itemWithView:self.vc2.view
                                                           title:self.vc2.title]
                                    ]];
}

@end
