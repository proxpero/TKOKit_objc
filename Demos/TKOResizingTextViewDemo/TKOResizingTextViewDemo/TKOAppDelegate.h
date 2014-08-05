//
//  TKOAppDelegate.h
//  TKOResizingTextViewDemo
//
//  Created by Todd Olsen on 7/10/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class TKOResizingTextView;

@interface TKOAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet TKOResizingTextView *textView;

@end
