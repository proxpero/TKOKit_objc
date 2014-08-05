//
//  TKOAppDelegate.h
//  TKOStackingSidebarDemo
//
//  Created by Todd Olsen on 7/4/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TKOStackingSidebarView;
@interface TKOAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet TKOStackingSidebarView *stackingSidebar;
@property (weak) IBOutlet NSTabView *tabView;

@end
