//
//  TKOAppDelegate.h
//  TKOThemedTextViewDemo
//
//  Created by Todd Olsen on 7/9/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TKOThemedTextView;

@interface TKOAppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSScrollView *scrollView;
@property (assign) IBOutlet NSWindow *window;
@property (nonatomic) TKOThemedTextView * textView;

@end
