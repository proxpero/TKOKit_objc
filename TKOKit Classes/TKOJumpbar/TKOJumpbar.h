//
//  TKOJumpbar.h
//  Keystone
//
//  Created by Todd Olsen on 12/29/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TKOJumpbar;

@protocol TKOJumpbarDelegate <NSObject>

@optional

- (void)jumpbarDidChangeSelection:(NSNotification *)notification;
- (void)jumpbar:(TKOJumpbar *)jumpbar setSelectedItem:(id)selectedItem;

@end

extern NSString * TKOJumpbarDidChangeSelectionNotification;

@protocol TKOJumpbarItem <NSObject>

- (NSString *)name;
+ (NSImage *)image;

@end

@interface TKOJumpbar : NSControl

@property (nonatomic, strong) id selectedItem;
@property (nonatomic, weak) id <TKOJumpbarDelegate> delegate;

@end
