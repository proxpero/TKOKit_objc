//
//  TKOAppDelegate.m
//  TKOResizingTextViewDemo
//
//  Created by Todd Olsen on 7/10/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOAppDelegate.h"
#import "TKOThemeLoader.h"
#import "TKOTheme.h"

#import "TKOResizingTextView.h"

@implementation TKOAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    TKOThemeLoader * themeLoader = [[TKOThemeLoader alloc] init];
    TKOTheme * theme = [themeLoader themeNamed:@"TKOProblemEditor"];
    self.textView.theme = theme;
}

@end
