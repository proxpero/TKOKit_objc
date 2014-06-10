//
//  TKOAppDelegate.m
//  TKOTextItemViewDemo
//
//  Created by Todd Olsen on 6/4/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOAppDelegate.h"
#import "TKOTextListItem.h"

@implementation TKOAppDelegate
{
    NSMutableArray * items;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    items = [NSMutableArray new];
    [items addObject:[self newItem]];
    self.textListControl.datasource = self;
}

- (TKOTextListItem *)newItem
{
    TKOTextListItem * newItem = [[TKOTextListItem alloc] initWithFrame:NSZeroRect];
    [newItem setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary * attributes = @{
                                  NSFontAttributeName: [NSFont fontWithName:@"Baskerville" size:20],
                                  NSForegroundColorAttributeName: [NSColor darkGrayColor]
                                  };
    NSAttributedString * astr = [[NSAttributedString alloc] initWithString:@""
                                                                attributes:attributes];
    [newItem.textView.textStorage setAttributedString:astr];
    return newItem;
}

- (NSUInteger)listControlNumberOfItems:(TKOTextListControl *)listControl
{
    return items.count;
}

- (TKOTextListItem *)listControl:(TKOTextListControl *)listControl textListItemAtIndex:(NSUInteger)index
{
    return items[index];
}

- (NSString *)listControlPlaceholder:(TKOTextListControl *)listControl
{
    return @"New Choice";
}

- (TKOListMarkerFormat)listControlMarkerFormatForItems:(TKOTextListControl *)listControl
{
    return TKOListMarkerFormatUpperRoman;
}

- (void)listControl:(TKOTextListControl *)listControl insertSiblingForListItem:(TKOTextListItem *)textListItem
{
    NSInteger index = [items indexOfObject:textListItem] + 1;
    TKOTextListItem * item = [self newItem];
    [items insertObject:item atIndex:index];
    [self.textListControl reloadData];
    [self.window makeFirstResponder:item.textView];
}

- (void)listControl:(TKOTextListControl *)listControl removeItem:(TKOTextListItem *)textListItem
{
    [items removeObject:textListItem];
    [self.textListControl reloadData];
}

@end
