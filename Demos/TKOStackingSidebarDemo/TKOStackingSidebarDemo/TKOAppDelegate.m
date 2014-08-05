//
//  TKOAppDelegate.m
//  TKOStackingSidebarDemo
//
//  Created by Todd Olsen on 7/4/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOAppDelegate.h"
#import "TKOStackingSidebarView.h"
#import "TKOSegmentedItem.h"
#import "TKOThemeLoader.h"
#import "TKOTheme.h"
#import "TKOThemeConstants.h"

@interface TKOAppDelegate ()

@property (nonatomic) NSMutableDictionary * vcs;

@end

@implementation TKOAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    TKOThemeLoader * themeloader = [[TKOThemeLoader alloc] init];
    TKOTheme * theme = [themeloader defaultTheme];
    
    self.stackingSidebar.target = self;
    self.stackingSidebar.action = @selector(selectItem:);
    
    self.stackingSidebar.buttonHeight                   = [theme floatForKey:TKOSidebarControlHeight];
    self.stackingSidebar.font                           = [theme fontForKey:TKOSidebarControlFont];
    self.stackingSidebar.borderMask                     = TKOBorderMaskBottom;
    self.stackingSidebar.borderHighlightMask            = TKOBorderMaskTop|TKOBorderMaskRight|TKOBorderMaskBottom|TKOBorderMaskLeft;
    self.stackingSidebar.borderColor                    = [theme colorForKey:TKOSidebarControlBorderColor];
    self.stackingSidebar.borderHighlightColor           = [theme colorForKey:TKOSidebarControlBorderHighlightColor];
    self.stackingSidebar.backgroundColor                = [theme colorForKey:TKOSidebarControlBackgroundColor];
    self.stackingSidebar.backgroundHighlightColor       = [theme colorForKey:TKOSidebarControlBackgroundHighlightColor];
    self.stackingSidebar.textColor                      = [theme colorForKey:TKOSidebarControlTextColor];
    self.stackingSidebar.textHighlightColor             = [theme colorForKey:TKOSidebarControlTextHighlightColor];
    self.stackingSidebar.imageColor                     = [theme colorForKey:TKOSidebarControlImageColor];
    self.stackingSidebar.imageHighlightColor            = [theme colorForKey:TKOSidebarControlImageHighlightColor];
    self.stackingSidebar.backgroundGradient             = [theme colorGradientForKey:TKOSidebarControlBackgroundGradient];
    self.stackingSidebar.backgroundHighlightGradient    = [theme colorGradientForKey:TKOSidebarControlBackgroundHighlightGradient];
    self.stackingSidebar.gradientAngle                  = [theme floatForKey:TKOSidebarControlGradientAngle];
    self.stackingSidebar.verticalTextOffset             = [theme floatForKey:TKOSidebarControlVerticalTextOffset];
    self.stackingSidebar.verticalImageOffset            = [theme floatForKey:TKOSidebarControlVerticalImageOffset];
    
    NSDictionary * students     = @{ TKOSidebarItemLabelKey: @"Students",       TKOSidebarItemImageKey: [NSImage imageNamed:@"TKOStudentsTemplate"],    TKOSidebarItemTagKey: @(0), TKOSidebarItemGravityKey: @(NSStackViewGravityTop) };
    NSDictionary * assignemnts  = @{ TKOSidebarItemLabelKey: @"Assignments",    TKOSidebarItemImageKey: [NSImage imageNamed:@"TKOAssignmentsTemplate"], TKOSidebarItemTagKey: @(1), TKOSidebarItemGravityKey: @(NSStackViewGravityTop) };
    NSDictionary * problems     = @{ TKOSidebarItemLabelKey: @"Problems",       TKOSidebarItemImageKey: [NSImage imageNamed:@"TKOProblemsTemplate"],    TKOSidebarItemTagKey: @(2), TKOSidebarItemGravityKey: @(NSStackViewGravityTop) };
    NSDictionary * lists        = @{ TKOSidebarItemLabelKey: @"Lists",          TKOSidebarItemImageKey: [NSImage imageNamed:@"TKOListsTemplate"],       TKOSidebarItemTagKey: @(3), TKOSidebarItemGravityKey: @(NSStackViewGravityTop) };
    NSDictionary * formats      = @{ TKOSidebarItemLabelKey: @"Formats",        TKOSidebarItemImageKey: [NSImage imageNamed:@"TKOFormatsTemplate"],     TKOSidebarItemTagKey: @(4), TKOSidebarItemGravityKey: @(NSStackViewGravityTop) };
    NSDictionary * tags         = @{ TKOSidebarItemLabelKey: @"Tags",           TKOSidebarItemImageKey: [NSImage imageNamed:@"TKOTagsTemplate"],        TKOSidebarItemTagKey: @(5), TKOSidebarItemGravityKey: @(NSStackViewGravityTop) };
    NSDictionary * standards    = @{ TKOSidebarItemLabelKey: @"Standards",      TKOSidebarItemImageKey: [NSImage imageNamed:@"TKOStandardsTemplate"],   TKOSidebarItemTagKey: @(6), TKOSidebarItemGravityKey: @(NSStackViewGravityTop) };
    NSDictionary * trash        = @{ TKOSidebarItemLabelKey: @"Trash",          TKOSidebarItemImageKey: [NSImage imageNamed:@"TKOTrashTemplate"],       TKOSidebarItemTagKey: @(NSIntegerMax), TKOSidebarItemGravityKey: @(NSStackViewGravityBottom) };

    NSArray * items = @[students, assignemnts, problems, lists, formats, tags, standards, trash];
    
    [self.stackingSidebar setItems:items];
    for (NSDictionary * dict in items) {
        NSTabViewItem * tvi = [[NSTabViewItem alloc] initWithIdentifier:dict[TKOSidebarItemLabelKey]];
        [self.tabView addTabViewItem:tvi];
    }
    
    self.vcs = [NSMutableDictionary new];
}

- (void)selectItem:(id)sender
{
    NSString * key = [sender selectedIdentifier];
    NSViewController * vc = self.vcs[key]; // lazy loading view controller
    
    if (vc) {
        [self.tabView selectTabViewItemWithIdentifier:key];
        return;
    }
    
    NSString * className = [NSString stringWithFormat:@"TKO%@ViewController", key];
    Class class = NSClassFromString(className);
    vc = [[class alloc] init];
    
    if (vc) {
        NSInteger index = [self.tabView indexOfTabViewItemWithIdentifier:key];
        NSTabViewItem * tvi = [self.tabView tabViewItemAtIndex:index];
        tvi.view = vc.view;
        [self.vcs setObject:vc forKey:key];
    }

    [self.tabView selectTabViewItemWithIdentifier:key];
}

@end
