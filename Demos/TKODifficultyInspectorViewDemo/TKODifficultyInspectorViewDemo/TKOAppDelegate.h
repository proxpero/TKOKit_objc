//
//  TKOAppDelegate.h
//  TKODifficultyInspectorViewDemo
//
//  Created by Todd Olsen on 3/19/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TKODifficultyInspectorViewController;
@interface TKOAppDelegate : NSObject <NSApplicationDelegate>
@property (weak) IBOutlet NSStackView *stackview;

@property (assign) IBOutlet NSWindow *window;
@property (strong, nonatomic) TKODifficultyInspectorViewController * difficultyInspector;

@end
