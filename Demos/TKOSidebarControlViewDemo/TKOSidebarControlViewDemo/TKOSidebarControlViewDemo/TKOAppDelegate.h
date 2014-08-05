//
//  TKOAppDelegate.h
//  TKOSidebarControlViewDemo
//
//  Created by Todd Olsen on 6/29/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TKOSidebarControlView.h"

@interface TKOAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet TKOSidebarControlView *sidebar;
@property (weak) IBOutlet NSTabView *tabView;

@end
