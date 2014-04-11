//
//  TKOSidebar.h
//  TKOSidebarDemo
//
//  Created by Todd Olsen on 4/7/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TKOButtonCell.h"

@class TKOSidebar;
@protocol TKOSidebarDataSource <NSObject>

- (NSUInteger)sidebarNumberOfTabs:(TKOSidebar *)sidebar;
- (NSString *)sidebar:(TKOSidebar *)sidebar titleAtIndex:(NSUInteger)index;
- (NSImage *)sidebar:(TKOSidebar *)sidebar imageAtIndex:(NSUInteger)index;
- (NSView *)sidebar:(TKOSidebar *)sidebar viewForIndex:(NSUInteger)index;

@optional

- (void)sidebarDidChangeSelection:(NSNotification *)notification;

@end

extern NSString * TKOSidebarDidChangeSelectionNotification;

@interface TKOSidebar : NSStackView

@property (nonatomic) id target;
@property (nonatomic) SEL action;

@property (nonatomic, copy) NSColor * backgroundColor;
@property (nonatomic, copy) NSColor * backgroundHighlightColor;
@property (nonatomic, copy) NSColor * imageColor;
@property (nonatomic, copy) NSColor * imageHighlightColor;
@property (nonatomic, copy) NSColor * textColor;
@property (nonatomic, copy) NSColor * textHighlightColor;
@property (nonatomic, copy) NSColor * borderColor;
@property (nonatomic, copy) NSColor * borderHighlightColor;
@property (nonatomic) TKOBorderMask borderMask;
@property (nonatomic) TKOBorderMask borderHighlightMask;

@property (nonatomic, weak) id selectedView;
@property (nonatomic, weak) id <TKOSidebarDataSource> dataSource;

- (void)addItemWithImage:(NSImage *)image
                   title:(NSString *)title
       representedObject:(id)representedObject
               inGravity:(NSStackViewGravity)gravity;

- (void)reloadData;
- (void)selectTab:(id)sender;

@end
