//
//  TKOTabView.h
//  TKOInspectorViewControllerDemo
//
//  Created by Todd Olsen on 2/18/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TKOTabView : NSView

@property (strong, nonatomic) NSArray * tabViewItems;

@end



@interface TKOTabViewItem : NSObject

@property (strong, nonatomic) NSView * view;
@property (strong, nonatomic) NSString * title;

+ (instancetype)itemWithView:(NSView *)view
                       title:(NSString *)title;

@end