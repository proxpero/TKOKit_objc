//
//  TKOAppDelegate.m
//  TKOTabViewDemo
//
//  Created by Todd Olsen on 6/19/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOAppDelegate.h"
#import "TKOTabView.h"

@interface TKOAppDelegate () <TKOTabViewDelegate>

@end

@implementation TKOAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.tabView.font                 = [NSFont fontWithName:@"HelveticaNeue-Light" size:12];
//    self.tabView.textColor            = [NSColor darkGrayColor];
//    self.tabView.highlightTextColor   = [NSColor yellowColor];
//    self.tabView.buttonColor          = [NSColor highlightColor];
//    self.tabView.highlightButtonColor = [NSColor purpleColor];
    
    self.tabView.tabViewItems = @[self.vc1, self.vc2, self.vc3];
    self.tabView.delegate = self;
}

//- (BOOL)tabView:(TKOTabView *)tabView shouldSelectTabViewItem:(id<TKOTabViewItem>)tabViewItem
//{
//    return tabViewItem != (id <TKOTabViewItem>)self.vc2;
//}

- (void)tabView:(TKOTabView *)tabView willSelectTabViewItem:(id<TKOTabViewItem>)tabViewItem
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)tabView:(TKOTabView *)tabView didSelectTabViewItem:(id<TKOTabViewItem>)tabViewItem
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


@end
