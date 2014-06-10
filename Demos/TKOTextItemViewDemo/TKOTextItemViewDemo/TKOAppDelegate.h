//
//  TKOAppDelegate.h
//  TKOTextItemViewDemo
//
//  Created by Todd Olsen on 6/4/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TKOTextListControl.h"

@interface TKOAppDelegate : NSObject <NSApplicationDelegate, TKOTextListDataSource>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet TKOTextListControl *textListControl;

@end
