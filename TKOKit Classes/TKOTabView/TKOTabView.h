//
//  TKOTabView.h
//  TKOTabViewDemo
//
//  Created by Todd Olsen on 6/19/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol TKOTabViewItem <NSObject>
@required

- (NSString *)title;
- (NSView *)view;

@end

@class TKOTabView;

@protocol TKOTabViewDelegate <NSObject>
@optional

- (void)tabViewDidChangeNumberOfTabViewItems:(TKOTabView *)tabView;
- (BOOL)tabView:(TKOTabView *)tabView shouldSelectTabViewItem:(id <TKOTabViewItem>)tabViewItem; // defaults to YES
- (void)tabView:(TKOTabView *)tabView willSelectTabViewItem:(id <TKOTabViewItem>)tabViewItem;
- (void)tabView:(TKOTabView *)tabView didSelectTabViewItem:(id <TKOTabViewItem>)tabViewItem;

@end

@interface TKOTabView : NSView

// Tab View Items is an array of id <TKOTabViewItem> objects, like TKOTabViewItem objects
// or an (id <TKOTabViewItem>) e.g. an NSViewController.

@property (nonatomic) NSArray * tabViewItems;

@property (nonatomic) NSFont  * font;                   // defaults to system font of 'regular' size
@property (nonatomic) NSColor * buttonColor;            // defaults to control color
@property (nonatomic) NSColor * highlightButtonColor;   // defaults to highlight color
@property (nonatomic) NSColor * textColor;              // defaults to text color
@property (nonatomic) NSColor * highlightTextColor;     // defaults to blue color
@property (nonatomic) NSColor * imageColor;             // defaults to text color
@property (nonatomic) NSColor * highlightImageColor;    // defaults to blue color

@property (nonatomic, weak) id <TKOTabViewDelegate> delegate;

@end

struct {
    unsigned int didChangeNumberOfTabViewItems:1;
    unsigned int shouldSelectTabViewItem:1;
    unsigned int willSelectTabViewItem:1;
    unsigned int didSelectTabViewItem:1;
} delegateRespondsTo;

@interface TKOTabViewItem : NSObject <TKOTabViewItem>

@property (nonatomic, readonly) NSString * title;
@property (nonatomic, readonly) NSView   * view;

- (instancetype)initWithTitle:(NSString *)title view:(NSView *)view;

@end