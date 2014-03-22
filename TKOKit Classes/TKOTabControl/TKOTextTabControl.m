//
//  TKOTextTabControl.m
//  Keystone
//
//  Created by Todd Olsen on 12/12/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "TKOTextTabControl.h"
#import "TKOTextTabCell.h"
#import "NSView+TKOKit.h"

@implementation TKOTextTabControl

- (void)reloadData
{
    NSMutableArray *newItems = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0, count = [self.dataSource tabControlNumberOfTabs:self]; i < count; i++) {
        [newItems addObject:[self.dataSource tabControl:self
                                            itemAtIndex:i]];
    }
    
    NSMutableArray *newTabs = [[NSMutableArray alloc] init];
    
    [newItems enumerateObjectsUsingBlock:^(id item, NSUInteger index, BOOL *stop) {
        
        NSString * title = [self.dataSource tabControl:self
                                          titleForItem:item];
        NSButton * button = [self tabWithTitle:title];
        
        TKOHeaderCell * cell = [button cell];
        
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
        [newTabs addObject:button];
        
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
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|"
                                                 options:0
                                                 metrics:nil
                                                   views:@{@"button": button}]];
        
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:button
                                      attribute:NSLayoutAttributeLeading
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:(prev != nil ? prev : self)
                                      attribute:(prev != nil ? NSLayoutAttributeTrailing : NSLayoutAttributeLeading)
                                     multiplier:1
                                       constant:0]
         ];
        if (prev != nil) {
            [self addConstraint:
             [NSLayoutConstraint constraintWithItem:button
                                          attribute:NSLayoutAttributeWidth
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:prev
                                          attribute:NSLayoutAttributeWidth
                                         multiplier:1
                                           constant:0]];
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

- (NSButton *)tabWithTitle:(NSString *)title
{
    TKOTextTabCell * tabCell = [[TKOTextTabCell alloc] initTextCell:title];
    tabCell.imagePosition    = NSNoImage;
    tabCell.font             = dataSourceRespondsTo.fontForTabControl ? [self.dataSource fontForTabControl:self] : nil;
    tabCell.target           = self;
    tabCell.action           = @selector(selectTab:);
    tabCell.menu             = nil;
    [tabCell sendActionOn:NSLeftMouseDownMask];

    NSButton * tab = [NSView viewWithClass:[NSButton class]];
    
    // Answer Choice Only
    
    tab.wantsLayer = YES;
    tab.layer.borderWidth = 1.0;
    tab.layer.cornerRadius = 5.0;
    
    //
    
    [tab setCell:tabCell];

    return tab;
}

@end


