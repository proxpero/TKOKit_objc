//
//  TKOTemplatePicker.h
//  TKOProblemTemplateClassDemo
//
//  Created by Todd Olsen on 3/10/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TKOTemplatePicker;

@protocol TKOTemplatePickerDataSource <NSObject>

- (NSUInteger)templatePickerNumberOfItems:(TKOTemplatePicker *)templatePicker;
- (id)templatePicker:(TKOTemplatePicker *)templatePicker
         itemAtIndex:(NSUInteger)index;
- (NSString *)templatePicker:(TKOTemplatePicker *)templatePicker
                titleForItem:(id)item;
@end

@protocol TKOTemplatePickerDelegate <NSObject>
@optional

- (void)templatePickerDidChangeSelection:(NSNotification *)notification;

@end

extern NSString * TKOTemplatePickerDidChangeSelectionNotification;

@interface TKOTemplatePicker : NSView

@property (weak, nonatomic) IBOutlet id <TKOTemplatePickerDelegate> delegate;
@property (weak, nonatomic) IBOutlet id <TKOTemplatePickerDataSource> dataSource;
@property (nonatomic, weak) id selectedItem;

- (id)initWithTitle:(NSString *)title;
- (void)reloadData;

@end
