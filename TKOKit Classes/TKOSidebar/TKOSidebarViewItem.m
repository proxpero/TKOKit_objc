//
//  TKOSidebarViewItem.m
//  TKOSidebarDemo
//
//  Created by Todd Olsen on 4/11/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOSidebarViewItem.h"

@implementation TKOSidebarViewItem

- (id)initWithTitle:(NSString *)title
               icon:(NSImage *)icon
               view:(NSView *)view
            gravity:(NSStackViewGravity)gravity
{
    self = [super init];
    if (!self) return nil;
    
    _title = title.copy;
    _icon = icon;
    _view = view;
    _gravity = gravity;
    
    return self;
}

@end
