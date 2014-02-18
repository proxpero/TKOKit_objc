//
//  TKOImageTabControl.m
//  Keystone
//
//  Created by Todd Olsen on 12/12/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "TKOImageTabControl.h"
#import "TKOImageTabCell.h"

#define TKODefaultImageColor [NSColor darkGrayColor]
#define TKODefaultHighlightImageColor [NSColor blueColor]

@implementation TKOImageTabControl
{
    NSButton * leftSpacer;
    NSButton * rightSpacer;
}

- (void)reloadData
{
    NSMutableArray *newItems = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0, count = [self.dataSource tabControlNumberOfTabs:self]; i < count; i++) {
        [newItems addObject:[self.dataSource tabControl:self
                                            itemAtIndex:i]];
    }
    
    NSMutableArray *newTabs = [[NSMutableArray alloc] init];
    
    if (!leftSpacer) {
        leftSpacer = [NSView viewWithClass:[NSButton class]];
        TKOHeaderCell * cell = [[TKOHeaderCell alloc] init];
        cell.target     = nil;
        cell.action     = nil;
        cell.borderMask = TKOBorderMaskBottom;
        leftSpacer.cell = cell;
    }
    
    [newTabs addObject:leftSpacer];
    
    for (id item in newItems) {
        
        NSImage * image = [self.dataSource tabControl:self
                                         imageForItem:item];
        NSButton * button = [self tabWithImage:image];
        
        TKOImageTabCell * cell = [button cell];

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
        if (dataSourceRespondsTo.imageColorForTabControl)
            [cell setImageColor:[self.dataSource imageColorForTabControl:self]];
        if (dataSourceRespondsTo.imageHighlightColorForTabControl)
            [cell setImageHighlightColor:[self.dataSource imageHighlightColorForTabControl:self]];
        
        [cell setRepresentedObject:item];
        [newTabs addObject:button];
    }

    if (!rightSpacer) {
        rightSpacer = [NSView viewWithClass:[NSButton class]];
        TKOHeaderCell * cell = [[TKOHeaderCell alloc] init];
        cell.target         = nil;
        cell.action         = nil;
        cell.borderMask     = TKOBorderMaskBottom;
        rightSpacer.cell    = cell;
        [newTabs addObject:rightSpacer];
    }
    
    [self setSubviews:newTabs];
    [self layoutTabs:newTabs];
    self.items = newItems;
}

- (void)layoutTabs:(NSArray *)tabs
{
    [self removeConstraints:self.constraints];
    
    NSButton *prev = nil;
    
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:rightSpacer
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:leftSpacer
                                  attribute:NSLayoutAttributeWidth
                                 multiplier:1
                                   constant:0]];
    
    for (NSButton * button in tabs) {
        
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|"
                                                 options:0
                                                 metrics:nil
                                                   views:@{@"button":button}]];
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:button
                                      attribute:NSLayoutAttributeLeading
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:(prev != nil ? prev : self)
                                      attribute:(prev != nil ? NSLayoutAttributeTrailing : NSLayoutAttributeLeading)
                                     multiplier:1
                                       constant:0]];
        
        if (![button isEqual:leftSpacer] && ![button isEqual:rightSpacer]) {
            [self addConstraint:
             [NSLayoutConstraint constraintWithItem:button
                                          attribute:NSLayoutAttributeWidth
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:nil
                                          attribute:NSLayoutAttributeNotAnAttribute
                                         multiplier:1
                                           constant:self.bounds.size.height]];
        }
        prev = button;
    }
    
    if (prev) {
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:prev
                                      attribute:NSLayoutAttributeTrailing
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeTrailing
                                     multiplier:1
                                       constant:0]];
    }
}

- (NSButton *)tabWithImage:(NSImage *)image
{
    TKOImageTabCell * tabCell = [[TKOImageTabCell alloc] initImageCell:image];
    
    tabCell.imagePosition   = NSImageOnly;
    tabCell.borderMask      = TKOBorderMaskBottom;
    
    tabCell.target = self;
    tabCell.action = @selector(selectTab:);
    tabCell.menu   = nil;
    
    [tabCell sendActionOn:NSLeftMouseDownMask];
    
    NSButton * tab = [NSView viewWithClass:[NSButton class]];
    [tab setCell:tabCell];
    
    [tab addConstraint:[NSLayoutConstraint constraintWithItem:tab
                                                    attribute:NSLayoutAttributeHeight
                                                    relatedBy:NSLayoutRelationEqual
                                                       toItem:nil
                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                   multiplier:1.0
                                                     constant:self.bounds.size.height]];
    return tab;
}

@end
