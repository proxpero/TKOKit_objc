//
//  TKOAppDelegate.m
//  TKOThemedTextViewDemo
//
//  Created by Todd Olsen on 7/9/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOAppDelegate.h"
#import "TKOThemeLoader.h"
#import "TKOTheme.h"
#import "TKOThemedTextView.h"

@implementation TKOAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    TKOThemeLoader * themeLoader = [[TKOThemeLoader alloc] init];
    TKOTheme * theme = [themeLoader themeNamed:@"TKOProblemEditor"];
    self.textView = [[TKOThemedTextView alloc] initWithTheme:theme];
    self.scrollView.documentView = self.textView;
}

@end
