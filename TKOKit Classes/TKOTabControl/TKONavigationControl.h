//
//  TKONavigationControl.h
//  Keystone
//
//  Created by Todd Olsen on 12/13/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TKONavigationControl;

@protocol TKONavigationControlDelegate <NSObject>

- (void)navigationControlDidClickBackButton:(NSNotification *)notification;
- (NSString *)titleForNavigationControl:(TKONavigationControl *)navigationControl;
- (BOOL)navigationControlShouldEnableBackButton:(TKONavigationControl *)navigationControl;

@end

extern NSString * TKONavigationControlDidClickBackButtonNotification;

@interface TKONavigationControl : NSControl

@property (weak, nonatomic) id <TKONavigationControlDelegate> delegate;
- (void)reloadData;

@end
