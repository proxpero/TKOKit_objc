//
//  TKOAppDelegate.h
//  TKOSegmentedControlDemo
//
//  Created by Todd Olsen on 6/26/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TKOSegmentedControlView;
@interface TKOAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet TKOSegmentedControlView *segmentedControl;

@end
