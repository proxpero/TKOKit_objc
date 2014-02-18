//
//  TKOTabControlDataSource.h
//  Keystone
//
//  Created by Todd Olsen on 1/3/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TKOTabControl;

@protocol TKOTabControlDataSource <NSObject>

- (NSUInteger)tabControlNumberOfTabs:(TKOTabControl *)tabControl;

- (id)tabControl:(TKOTabControl *)tabControl
     itemAtIndex:(NSUInteger)index;

@optional

- (NSString *)tabControl:(TKOTabControl *)tabControl
            titleForItem:(id)item;

- (NSImage *)tabControl:(TKOTabControl *)tabControl
           imageForItem:(id)item;

- (NSMenu *)tabControl:(TKOTabControl *)tabControl
           menuForItem:(id)item;

- (void)tabControlWillChangeSelection:(NSNotification *)notification;
- (void)tabControlDidChangeSelection:(NSNotification *)notification;

- (NSFont *)fontForTabControl:(TKOTabControl *)tabControl;
- (NSColor *)backgroundColorForTabControl:(TKOTabControl *)tabControl;
- (NSColor *)backgroundHighlightColorForTabControl:(TKOTabControl *)tabControl;
- (NSColor *)borderColorForTabControl:(TKOTabControl *)tabControl;
- (NSColor *)borderHighlightColorForTabControl:(TKOTabControl *)tabControl;
- (NSColor *)textColorForTabControl:(TKOTabControl *)tabControl;
- (NSColor *)textHighlightColorForTabControl:(TKOTabControl *)tabControl;
- (NSColor *)imageColorForTabControl:(TKOTabControl *)tabControl;
- (NSColor *)imageHighlightColorForTabControl:(TKOTabControl *)tabControl;

@end

extern NSString * TKOTabControlSelectionWillChangeNotification;
extern NSString * TKOTabControlSelectionDidChangeNotification;

struct {
    unsigned int fontForTabControl:1;
    unsigned int backgroundColorForTabControl:1;
    unsigned int backgroundHighlightColorForTabControl:1;
    unsigned int borderColorForTabControl:1;
    unsigned int borderHighlightColorForTabControl:1;
    unsigned int textColorForTabControl:1;
    unsigned int textHighlightColorForTabControl:1;
    unsigned int imageColorForTabControl:1;
    unsigned int imageHighlightColorForTabControl:1;
} dataSourceRespondsTo;
