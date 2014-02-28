//
//  TKOFlexibleToolbarItem.h
//  Keystone
//
//  Created by Todd Olsen on 1/1/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TKOFlexibleToolbarItem : NSToolbarItem
@property (nonatomic, weak) NSView *linkedView;
//@property (nonatomic, strong) NSPopUpButton * popupButton;
@property (nonatomic, strong) NSView * auxilliaryView;
//- (void)configureView;
- (void)updateWidth;

@end
