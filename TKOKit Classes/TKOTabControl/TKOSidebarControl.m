//
//  TKOSidebarControl.m
//  TKOFormatInspectorDemo
//
//  Created by Todd Olsen on 4/7/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOSidebarControl.h"
#import "TKOControl.h"

@implementation TKOSidebarControl

- (void)reloadData
{
    NSMutableArray *newItems = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0, count = [self.dataSource tabControlNumberOfTabs:self]; i < count; i++) {
        [newItems addObject:[self.dataSource tabControl:self itemAtIndex:i]];
    }
    
    NSMutableArray *newTabs = [[NSMutableArray alloc] init];
    
    [newItems enumerateObjectsUsingBlock:^(id item, NSUInteger index, BOOL *stop)
    {
        NSImage * image = [self.dataSource tabControl:self imageForItem:item];
        TKOControl * tab = [self tabWithImage:image];
        
        TKOHeaderCell * cell = [tab cell];
        
        if (dataSourceRespondsTo.backgroundColorForTabControl)
            [cell setBackgroundColor:[self.dataSource backgroundColorForTabControl:self]];
        if (dataSourceRespondsTo.backgroundHighlightColorForTabControl)
            [cell setBackgroundHighlightColor:[self.dataSource backgroundHighlightColorForTabControl:self]];
        if (dataSourceRespondsTo.borderColorForTabControl)
            [cell setBorderColor:[self.dataSource borderColorForTabControl:self]];
        if (dataSourceRespondsTo.borderHighlightColorForTabControl)
            [cell setBorderHighlightColor:[self.dataSource borderHighlightColorForTabControl:self]];
        if (dataSourceRespondsTo.textColorForTabControl)
            [cell setTextColor:[self.dataSource textColorForTabControl:self]];
        if (dataSourceRespondsTo.textHighlightColorForTabControl)
            [cell setTextHighlightColor:[self.dataSource textHighlightColorForTabControl:self]];
        if (dataSourceRespondsTo.borderMaskForItemAtIndex)
            [cell setBorderMask:[self.dataSource tabControl:self borderMaskForItemAtIndex:index]];
        
        [cell setRepresentedObject:item];
        [newTabs addObject:tab];
        
    }];
    
    [self setSubviews:newTabs];
    [self layoutTabs:newTabs];
    
    self.items = newItems;
}

- (void)layoutTabs:(NSArray *)tabs
{
    // remove old constraints, if any...
    //    [self removeConstraints:self.constraints];
    
    // constrain passed tabs into a horizontal list...
    NSButton * prev = nil;
    
    for (NSButton * button in tabs) {
        
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button]|"
                                                 options:0
                                                 metrics:nil
                                                   views:@{@"button": button}]];
        
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:button
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:(prev != nil ? prev : self)
                                      attribute:(prev != nil ? NSLayoutAttributeBottom : NSLayoutAttributeTop)
                                     multiplier:1
                                       constant:0]
         ];
        if (prev != nil) {
            [self addConstraint:
             [NSLayoutConstraint constraintWithItem:button
                                          attribute:NSLayoutAttributeHeight
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:prev
                                          attribute:NSLayoutAttributeHeight
                                         multiplier:1
                                           constant:0]];
        }
        
        prev = button;
    }
    
    if (prev) {
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:prev
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                       constant:0]];
    }
}

- (TKOControl *)tabWithImage:(NSImage *)image
{
    TKOControl * tab = [NSView viewWithClass:[TKOControl class]];
    
    
    
    
    
    return tab;
}

@end
