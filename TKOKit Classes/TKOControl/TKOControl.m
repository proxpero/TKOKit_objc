//
//  TKOControl.m
//  TKOKit
//
//  Created by Todd Olsen on 1/29/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOControl.h"
#import "TKOButtonCell.h"
#import "NSColor+TKOKit.h"
#import "NSView+TKOKit.h"
#import "TKOTheme.h"

@interface TKOControl ()

@end

@implementation TKOControl

+ (Class)cellClass
{
    return [TKOButtonCell class];
}

- (void)setTheme:(TKOTheme *)theme
{
    if (_theme == theme)
        return;
    _theme = theme;

    NSString * key = self.identifier;
    if (!key) key = @"";
    
    [self.cell setBackgroundColor:[self.theme colorForKey:[NSString stringWithFormat:@"%@BackgroundColor", key]]];
    [self.cell setBackgroundHighlightColor:[self.theme colorForKey:[NSString stringWithFormat:@"%@HighlightBackgroundColor", key]]];
    [self.cell setBorderColor:[self.theme colorForKey:[NSString stringWithFormat:@"%@BorderColor", key]]];
    [self.cell setBorderHighlightColor:[self.theme colorForKey:[NSString stringWithFormat:@"%@HighlightBorderColor", key]]];

    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (BOOL)isOpaque
{
    return YES;
}

- (BOOL)isFlipped
{
    return YES;
}

@end
