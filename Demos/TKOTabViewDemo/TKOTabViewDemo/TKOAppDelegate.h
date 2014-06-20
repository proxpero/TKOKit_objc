//
//  TKOAppDelegate.h
//  TKOTabViewDemo
//
//  Created by Todd Olsen on 6/19/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TKOTabView;
@interface TKOAppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet TKOTabView *tabView;
@property (unsafe_unretained) IBOutlet NSViewController *vc1;
@property (unsafe_unretained) IBOutlet NSViewController *vc2;
@property (unsafe_unretained) IBOutlet NSViewController *vc3;

@property (assign) IBOutlet NSWindow *window;

@end
