//
//  NSTableView+TKOKit.h
//  TKOResizingScrollViewDemo
//
//  Created by Todd Olsen on 2/28/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol TKODynamicTableViewDataSource <NSTableViewDataSource>

// required by NSScrollView+TKOKit's -updateHeight method
- (NSInteger)maximumNumberOfVisibleRowsInTableView:(NSTableView *)tableView;

@end

@interface NSTableView (TKOKit)
@end
