//
//  TKODraggingTableViewDataSource.h
//  TKODragDropTableView
//
//  Created by Todd Olsen on 6/24/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TKOIndexReassignable <NSObject>
- (void)reassignToIndex:(NSUInteger)newIndex;
@end

@interface TKODraggingTableViewDataSource : NSObject <NSTableViewDataSource>

@property (nonatomic) id items;
@property (nonatomic) id filteredItems;

@end
