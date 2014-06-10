//
//  TKOProblemEditorListComponentView.h
//  Keystone
//
//  Created by Todd Olsen on 6/4/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import "TKOItemTextView.h"
//#import "TKOTextListItem.h"

typedef NS_ENUM(NSUInteger, TKOListMarkerFormat) {
    TKOListMarkerFormatNone,
    TKOListMarkerFormatUpperAlpha,
    TKOListMarkerFormatLowerAlpha,
    TKOListMarkerFormatUpperRoman,
    TKOListMarkerFormatLowerRoman,
};

@class TKOProblemEditorListComponentView;

@protocol TKOTextListDataSource <NSObject>

//- (NSUInteger)listControlNumberOfItems:(TKOProblemEditorListComponentView *)listControl;
//- (NSString *)listControlPlaceholder:(TKOProblemEditorListComponentView *)listControl;
//- (TKOListMarkerFormat)listControlMarkerFormatForItems:(TKOProblemEditorListComponentView *)listControl;
//- (TKOTextListItem *)listControl:(TKOProblemEditorListComponentView *)listControl textListItemAtIndex:(NSUInteger)index;
//- (void)listControl:(TKOProblemEditorListComponentView *)listControl insertSiblingForListItem:(TKOTextListItem *)textListItem;
//- (void)listControl:(TKOProblemEditorListComponentView *)listControl removeItem:(TKOTextListItem *)textListItem;

@end

@interface TKOProblemEditorListComponentView : NSView // <TKOListItemDelegate>

@property (nonatomic) NSMutableArray * items;
@property (nonatomic) TKOListMarkerFormat markerFormat;
@property (nonatomic, weak) id <TKOTextListDataSource> datasource;

- (instancetype)initWithFont:(NSFont *)font placeholder:(NSString *)placeholder listMarkerFormat:(TKOListMarkerFormat)listMarkerFormat;
- (void)reloadData;

@end
