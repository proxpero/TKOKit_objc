//
//  TKOBackgroundView.m
//  TKOStackingSidebarDemo
//
//  Created by Todd Olsen on 7/6/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOBackgroundView.h"
#import "TKOTheme.h"
#import "TKOThemeLoader.h"

static TKOTheme * _theme = nil;

@interface TKOBackgroundView ()

@property (nonatomic) NSGradient * gradient;

@end

@implementation TKOBackgroundView

+ (void)initialize
{
    if (!_theme) {
        TKOThemeLoader * themeloader = [[TKOThemeLoader alloc] init];
        _theme = [themeloader defaultTheme];
    }
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
 
    if (!self.gradient) {
        self.gradient = [_theme colorGradientForKey:@"TKOSegmentedControlBackgroundGradient"];
    }
    [self.gradient drawInRect:self.bounds angle:90.0];
}

@end
