//
//  TKOSegmentedControlView.h
//  TKOSegmentedControlDemo
//
//  Created by Todd Olsen on 6/26/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import "TKOSegmentedItem.h"

@class TKOTheme, TKOButtonCell;
@class TKOSegmentedItem;

@interface TKOSegmentedControlView : NSView

@property (nonatomic) TKOTheme * theme;

@property (nonatomic) NSMutableArray * items;

@property (nonatomic) NSInteger selectedTag;
@property (nonatomic) NSInteger selectedIndex; // NSNotFound
@property (nonatomic, copy) NSString * selectedIdentifier;

@property (nonatomic, weak) id target;
@property (nonatomic) SEL action;

@property (nonatomic) CGFloat verticalTextOffset;
@property (nonatomic) CGFloat verticalImageOffset;
@property (nonatomic) CGFloat gradientAngle;

- (NSButton *)buttonForItem:(NSDictionary *)item;
- (void)applyThemeToCell:(TKOButtonCell *)cell;

- (void)addItemWithWithLabel:(NSString *)label image:(NSImage *)image tag:(NSInteger)tag;

@end




