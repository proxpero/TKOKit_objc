//
//  TKOTabView.h
//  TKOInspectorViewControllerDemo
//
//  Created by Todd Olsen on 2/18/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TKOTabView;

@protocol TKOTabViewDelegate <NSObject>

- (void)tabViewSelectionDidChange:(NSNotification *)notification;

@end

extern NSString * TKOTabViewSelectionDidChangeNotification;

@protocol TKOTabViewItem <NSObject>

- (NSString *)title;
- (NSView *)view;

+ (id)itemWithView:(NSView *)view
             title:(NSString *)title;

@end

@interface TKOTabView : NSView

@property (strong, nonatomic) NSArray * tabViewItems;
@property (weak, nonatomic) id <TKOTabViewDelegate> delegate;
@property (weak, nonatomic) id selectedItem;

@end

@interface TKOTabViewItem : NSObject

@property (strong, nonatomic) NSView * view;
@property (strong, nonatomic) NSString * title;

+ (instancetype)itemWithView:(NSView *)view
                       title:(NSString *)title;

@end