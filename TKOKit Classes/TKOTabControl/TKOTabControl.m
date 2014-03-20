//
//  TKOTabControl.m
//  Keystone
//
//  Created by Todd Olsen on 12/2/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "TKOTabControl.h"

@interface TKOTabControl ()
@end

@implementation TKOTabControl

+ (Class)cellClass {
    return [TKOHeaderCell class];
}

#pragma mark - Properties

- (void)setBorderMask:(TKOBorderMask)borderMask
{
    [self.cell setBorderMask:borderMask];
}

- (void)setBorderColor:(NSColor *)borderColor
{
    [self.cell setBorderColor:borderColor];
}

- (void)setBackgroundColor:(NSColor *)backgroundColor
{
    [self.cell setBackgroundColor:backgroundColor];
    
}

- (void)setDataSource:(id <TKOTabControlDataSource>)dataSource
{
    if (_dataSource != dataSource) {
        
        if (_dataSource && [_dataSource respondsToSelector:@selector(tabControlDidChangeSelection:)])
            [[NSNotificationCenter defaultCenter] removeObserver:_dataSource
                                                            name:TKOTabControlSelectionDidChangeNotification
                                                          object:self];
        if (_dataSource && [_dataSource respondsToSelector:@selector(tabControlWillChangeSelection:)])
            [[NSNotificationCenter defaultCenter] removeObserver:_dataSource
                                                            name:TKOTabControlSelectionWillChangeNotification
                                                          object:self];
        
        _dataSource = dataSource;
        
        if (_dataSource && [_dataSource respondsToSelector:@selector(tabControlDidChangeSelection:)])
            [[NSNotificationCenter defaultCenter] addObserver:_dataSource
                                                     selector:@selector(tabControlDidChangeSelection:)
                                                         name:TKOTabControlSelectionDidChangeNotification
                                                       object:self];
        if (_dataSource && [_dataSource respondsToSelector:@selector(tabControlWillChangeSelection:)])
            [[NSNotificationCenter defaultCenter] addObserver:_dataSource
                                                     selector:@selector(tabControlWillChangeSelection:)
                                                         name:TKOTabControlSelectionWillChangeNotification
                                                       object:self];
        
        dataSourceRespondsTo.fontForTabControl                      = [_dataSource respondsToSelector:@selector(fontForTabControl:)];
        dataSourceRespondsTo.backgroundColorForTabControl           = [_dataSource respondsToSelector:@selector(backgroundColorForTabControl:)];
        dataSourceRespondsTo.backgroundHighlightColorForTabControl  = [_dataSource respondsToSelector:@selector(backgroundHighlightColorForTabControl:)];
        dataSourceRespondsTo.borderColorForTabControl               = [_dataSource respondsToSelector:@selector(borderColorForTabControl:)];
        dataSourceRespondsTo.borderHighlightColorForTabControl      = [_dataSource respondsToSelector:@selector(borderHighlightColorForTabControl:)];
        dataSourceRespondsTo.textColorForTabControl                 = [_dataSource respondsToSelector:@selector(textColorForTabControl:)];
        dataSourceRespondsTo.textHighlightColorForTabControl        = [_dataSource respondsToSelector:@selector(textHighlightColorForTabControl:)];
        dataSourceRespondsTo.imageColorForTabControl                = [_dataSource respondsToSelector:@selector(imageColorForTabControl:)];
        dataSourceRespondsTo.imageHighlightColorForTabControl       = [_dataSource respondsToSelector:@selector(imageHighlightColorForTabControl:)];
        dataSourceRespondsTo.borderMaskForItemAtIndex               = [_dataSource respondsToSelector:@selector(tabControl:borderMaskForItemAtIndex:)];
        
        [self reloadData];
    }
}

- (void)reloadData
{
    NSAssert(1, @"Subclasses must override %s", __PRETTY_FUNCTION__);
}

#pragma mark - Selection

- (id)selectedItem
{
    for (NSButton *button in self.subviews) {
        if ([button state] == 1)
            return [[button cell] representedObject];
    }
    return nil;
}

- (void)setSelectedItem:(id)selectedItem
{
    for (NSButton * button in self.subviews) {
        if ([[[button cell] representedObject] isEqual:selectedItem]) {
            [button setState:1];
        } else {
            [button setState:0];
        }
    }
}

- (NSUInteger)selectedIndex
{
    __block NSUInteger index = NSNotFound;
    [self.subviews enumerateObjectsUsingBlock:^(NSButton * button, NSUInteger idx, BOOL *stop) {
        if ([button state] == NSOnState)
        {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [self.subviews enumerateObjectsUsingBlock:^(NSButton * button, NSUInteger idx, BOOL *stop) {
        if (idx == selectedIndex)
            [button setState:NSOnState];
        else
            [button setState:NSOffState];
    }];
}

- (void)selectTab:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TKOTabControlSelectionWillChangeNotification
                                                        object:self];
    NSButton * selectedButton = sender;
    
    for (NSButton * button in self.subviews) {
        if ([button isKindOfClass:[NSButton class]])
        [button setState:(button == selectedButton) ? 1 : 0];
    }
    
    [[NSApplication sharedApplication] sendAction:self.action
                                               to:self.target
                                             from:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TKOTabControlSelectionDidChangeNotification
                                                        object:self];
}

- (NSButton *)existingTabWithItem:(id)item
{
    for (NSButton * button in self.subviews) {
        if ([[[button cell] representedObject] isEqual:item])
            return button;
    }
    return nil;
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

NSString * TKOTabControlSelectionWillChangeNotification = @"TKOTextTabControlSelectionWillChangeNotification";
NSString * TKOTabControlSelectionDidChangeNotification  = @"TKOTextTabControlSelectionDidChangeNotification";
