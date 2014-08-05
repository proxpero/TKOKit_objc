//
//  TKOSegmentedSidebarView.h
//  TKOSegmentedSidebarDemo
//
//  Created by Todd Olsen on 6/26/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TKOSegmentedSidebarView : NSView

@property (nonatomic) NSMutableArray * items;

@property (nonatomic) NSInteger selectedTag;
@property (nonatomic) NSInteger selectedIndex; // NSNotFound

@property (nonatomic, weak) id target;
@property (nonatomic) SEL action;

//@property (nonatomic) CGFloat   width;                 // defaults to 80
@property (nonatomic) NSColor * borderColor;            // defaults to darkGrayColor


@end
