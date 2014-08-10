//
//  TKOSegmentedSidebarView.m
//  TKOSegmentedSidebarDemo
//
//  Created by Todd Olsen on 6/26/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOSegmentedSidebarView.h"
#import "TKOSegmentedItem.h"
#import "TKOThemeLoader.h"
#import "TKOTheme.h"

static NSString * const TKOSegmentedSidebarSpacing                  = @"TKOSegmentedSidebarSpacing";
static NSString * const TKOSegmentedSidebarFont                     = @"TKOSegmentedSidebarFont";
static NSString * const TKOSegmentedSidebarBorderColor              = @"TKOSegmentedSidebarBorderColor";
static NSString * const TKOSegmentedSidebarBackgroundColor          = @"TKOSegmentedSidebarBackgroundColor";
static NSString * const TKOSegmentedSidebarSegmentColor             = @"TKOSegmentedSidebarSegmentColor";
static NSString * const TKOSegmentedSidebarHighlightSegmentColor    = @"TKOSegmentedSidebarHighlightSegmentColor";
static NSString * const TKOSegmentedSidebarTextColor                = @"TKOSegmentedSidebarTextColor";
static NSString * const TKOSegmentedSidebarHighlightTextColor       = @"TKOSegmentedSidebarHighlightTextColor";
static NSString * const TKOSegmentedSidebarImageColor               = @"TKOSegmentedSidebarImageColor";
static NSString * const TKOSegmentedSidebarHighlightImageColor      = @"TKOSegmentedSidebarHighlightImageColor";

@interface TKOSegmentedSidebarView ()
@property (nonatomic) TKOTheme * theme;
@end

@implementation TKOSegmentedSidebarView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self configure];
    
    return self;
}

- (void)awakeFromNib
{
    [self configure];
}


- (void)configure
{
    static BOOL configured = NO; if (configured) return; configured = YES;
    self.wantsLayer = YES;
    
    TKOThemeLoader * themeLoader = [[TKOThemeLoader alloc] init];
    _theme = [themeLoader defaultTheme];
    
    _borderColor    = [_theme colorForKey:TKOSegmentedSidebarBorderColor];
    
    self.layer.backgroundColor = [_borderColor CGColor] ?: [[NSColor darkGrayColor] CGColor];

    _items = [NSMutableArray arrayWithArray:@[
                                              [[TKOSegmentedItem alloc] initWithLabel:@"Zero" image:nil tag:0],
                                              [[TKOSegmentedItem alloc] initWithLabel:@"One"  image:nil tag:1],
                                              [[TKOSegmentedItem alloc] initWithLabel:@"Two"  image:nil tag:2],
                                              ]];
    [self layoutItems];
}


- (void)setItems:(NSMutableArray *)items
{
    if (_items == items) return;
    _items = items;
    [self layoutItems];
}


- (void)layoutItems
{
    
}


@end
