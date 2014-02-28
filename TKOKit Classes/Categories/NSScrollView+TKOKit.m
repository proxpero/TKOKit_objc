//
//  NSScrollView+TKOKit.m
//  TKOResizingScrollViewDemo
//
//  Created by Todd Olsen on 2/28/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#define BUFFER 2

#import "NSScrollView+TKOKit.h"
#import "NSTableView+TKOKit.h"

@implementation NSScrollView (TKOKit)

- (void)updateHeight
{
    if (![self.documentView isKindOfClass:[NSTableView class]])
        return;
    
    NSTableView * tableView = self.documentView;
    
    if (![[tableView dataSource] respondsToSelector:@selector(numberOfRowsInTableView:)])
        return;
    
    NSInteger maxRows   = NSIntegerMax;
    CGFloat buffer      = BUFFER;
    
    if ([[tableView dataSource] respondsToSelector:@selector(maximumNumberOfVisibleRowsInTableView:)] &&
        [[tableView dataSource] conformsToProtocol:@protocol(TKODynamicTableViewDataSource)]) {
        id <TKODynamicTableViewDataSource> dataSource = (id <TKODynamicTableViewDataSource>)[tableView dataSource];
        maxRows = [dataSource maximumNumberOfVisibleRowsInTableView:tableView];
    }

    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d", NSLayoutAttributeHeight];
    NSLayoutConstraint * heightConstraint = [[self.constraints filteredArrayUsingPredicate:predicate] firstObject];
    
    CGFloat height = 0.0;
    NSInteger rows = [[tableView dataSource] numberOfRowsInTableView:tableView];
    
    height = [tableView rowHeight] + 2;
    height = (rows > maxRows) ? height * maxRows : height * rows;
    height += buffer;
   
    heightConstraint.constant = height;
}

@end
