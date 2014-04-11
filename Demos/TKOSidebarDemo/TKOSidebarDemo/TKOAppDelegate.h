//
//  TKOAppDelegate.h
//  TKOSidebarDemo
//
//  Created by Todd Olsen on 4/7/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TKOSidebarView.h"

@interface TKOAppDelegate : NSObject <NSApplicationDelegate, TKOSidebarViewDelegate>

@property (assign) IBOutlet NSWindow *window;

@end
