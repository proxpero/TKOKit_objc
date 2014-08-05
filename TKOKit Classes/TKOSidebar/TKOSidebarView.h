//
//  TKOSidebarView.h
//  TKOSidebarDemo
//
//  Created by Todd Olsen on 4/11/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TKOButtonCell.h"
#import "TKOSidebarViewItem.h"

typedef NS_ENUM(NSUInteger, TKOSidebarType) {
    TKOSidebarTypeLeft, // Default
    TKOSidebarTypeRight,
};

@class TKOSidebarView;
@protocol TKOSidebarViewDelegate <NSObject>
@optional

- (void)sidebarViewWillChangeSelection:(NSNotification *)notification;
- (void)sidebarViewDidChangeSelection:(NSNotification *)notification;

@end

extern NSString * TKOSidebarViewWillChangeSelectionNotification;
extern NSString * TKOSidebarViewDidChangeSelectionNotification;

@interface TKOSidebarView : NSView

@property (nonatomic, copy) NSColor * backgroundColor;
@property (nonatomic, copy) NSColor * backgroundHighlightColor;
@property (nonatomic, copy) NSColor * imageColor;
@property (nonatomic, copy) NSColor * imageHighlightColor;
@property (nonatomic, copy) NSColor * textColor;
@property (nonatomic, copy) NSColor * textHighlightColor;
@property (nonatomic, copy) NSColor * borderColor;
@property (nonatomic, copy) NSColor * borderHighlightColor;
@property (nonatomic) NSFont * font;

@property (nonatomic) TKOSidebarType sidebarType;

@property (nonatomic, weak) id selectedItem;
@property (nonatomic, weak) id <TKOSidebarViewDelegate> delegate;

@property (nonatomic) id target;
@property (nonatomic) SEL action;

// Add/Remove Tabs

- (void)addSidebarViewItem:(TKOSidebarViewItem *)sidebarViewItem;
- (void)insertSidebarViewItem:(TKOSidebarViewItem *)sidebarViewItem atIndex:(NSUInteger)index;
- (void)removeSidebarViewItem:(TKOSidebarViewItem *)sidebarViewItem;

// Selection

- (void)selectSidebarViewItem:(TKOSidebarViewItem *)sidebarViewItem;
- (void)selectSidebarViewItemAtIndex:(NSUInteger)index;

// Navigation

- (void)selectFirstTabViewItem:(id)sender;
- (void)selectLastTabViewItem:(id)sender;
- (void)selectNextTabViewItem:(id)sender;
- (void)selectPreviousTabViewItem:(id)sender;

// Query

- (NSUInteger)numberOfSidebarViewItems;
- (NSUInteger)indexOfSidebarViewItem:(TKOSidebarViewItem *)sidebarViewItem;			// NSNotFound if not found
- (TKOSidebarViewItem *)sidebarViewItemAtIndex:(NSUInteger)index;                    // May raise an NSRangeException

@end
