//
//  TKOSidebarViewItem.h
//  TKOSidebarDemo
//
//  Created by Todd Olsen on 4/11/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKOSidebarViewItem : NSObject

@property (nonatomic, readonly) NSString * title;
@property (nonatomic, readonly) NSImage * icon;
@property (nonatomic, readonly) NSView * view;
@property (nonatomic, readonly) NSStackViewGravity gravity;

- (id)initWithTitle:(NSString *)title
               icon:(NSImage *)icon
               view:(NSView *)view
            gravity:(NSStackViewGravity)gravity;

@end
