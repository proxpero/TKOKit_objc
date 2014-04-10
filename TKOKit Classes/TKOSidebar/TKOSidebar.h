//
//  TKOSidebar.h
//  TKOSidebarDemo
//
//  Created by Todd Olsen on 4/7/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TKOSidebar : NSStackView

@property (nonatomic) id target;
@property (nonatomic) SEL action;


- (void)addItemWithImage:(NSImage *)image
          alternateImage:(NSImage *)alternateImage
                   title:(NSString *)title
               inGravity:(NSStackViewGravity)gravity;

@end
