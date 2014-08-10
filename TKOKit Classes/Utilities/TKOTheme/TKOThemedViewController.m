//
//  TKOThemedViewController.m
//  TKOTabViewDemo
//
//  Created by Todd Olsen on 6/19/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOThemedViewController.h"
#import "TKOThemeLoader.h"
#import "TKOTheme.h"

@interface TKOThemedViewController ()

@end

@implementation TKOThemedViewController

- (id)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (!self) return nil;
    
    TKOThemeLoader * themeLoader = [[TKOThemeLoader alloc] init];
    _theme = [themeLoader defaultTheme];
    
    return self;
}

@end
