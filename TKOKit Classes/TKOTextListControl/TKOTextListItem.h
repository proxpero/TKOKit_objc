//
//  TKOTextListItem.h
//  TKOTextItemViewDemo
//
//  Created by Todd Olsen on 6/4/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TKOItemTextView.h"

@class TKOTextListItem;
@protocol TKOListItemDelegate <NSObject>

- (void)textListItemWantsNewSibling:(NSNotification *)notification;
- (void)textListItemWantsAdvancement:(NSNotification *)notification;
- (void)textListItemWantsPrevious:(NSNotification *)notification;
- (void)deleteTextListItem:(NSNotification *)notification;

@end

extern NSString * TKOTextListItemWantsNewSiblingNotification;
extern NSString * TKOTextListItemWantsAdvancementNotification;
extern NSString * TKOTextListItemWantsPreviousNotification;
extern NSString * TKODeleteTextListItemNotification;


@interface TKOTextListItem : NSView <NSTextViewDelegate>

@property (nonatomic) NSTextField * label;
@property (nonatomic) TKOItemTextView * textView;
@property (nonatomic, weak) id <TKOListItemDelegate> delegate;

@end


