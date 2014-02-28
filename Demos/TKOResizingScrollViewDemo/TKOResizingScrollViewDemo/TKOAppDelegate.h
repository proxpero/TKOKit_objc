//
//  TKOAppDelegate.h
//  TKOResizingScrollViewDemo
//
//  Created by Todd Olsen on 2/28/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TKOTableViewDelegate;

@interface TKOAppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet TKOTableViewDelegate *tableViewDelegate;
@property (assign) IBOutlet NSWindow *window;

@end
