//
//  TKOPopoverPickerControl.h
//  TKOInspectorViewControllerDemo
//
//  Created by Todd Olsen on 2/20/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TKOPopoverPickerControl;

@protocol TKOPopoverPickerControlDataSource <NSObject>

- (NSUInteger)popoverPickerNumberOfItems:(TKOPopoverPickerControl *)picker;

- (id)popoverPicker:(TKOPopoverPickerControl *)picker
        itemAtIndex:(NSUInteger)index;

- (NSString *)popoverPicker:(TKOPopoverPickerControl *)picker
               titleForItem:(id)item;

@end

@interface TKOPopoverPickerControl : NSControl

@end
