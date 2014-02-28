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

NSLayoutConstraint * heightConstraint = nil;

@implementation NSScrollView (TKOKit)

- (void)updateHeight
{
    if (![self.documentView isKindOfClass:[NSTableView class]])
        return;
    
    NSTableView * tableView = self.documentView;
    id dataSource = [tableView dataSource];
    
    if (![dataSource respondsToSelector:@selector(numberOfRowsInTableView:)])
        return;
    
    NSInteger rowsLimit = NSIntegerMax; // Unlimited number of visible rows
    
    BOOL responds = [dataSource respondsToSelector:@selector(maximumNumberOfVisibleRowsInTableView:)];
    BOOL conforms = [dataSource conformsToProtocol:@protocol(TKODynamicHeightTableViewDataSource)];
    
    if (responds && conforms) {
        id <TKODynamicHeightTableViewDataSource> dataSource = (id <TKODynamicHeightTableViewDataSource>)[tableView dataSource];
        rowsLimit = [dataSource maximumNumberOfVisibleRowsInTableView:tableView];
        if (rowsLimit < 0)
            rowsLimit = 0;
    }
    
    NSInteger rows      = [[tableView dataSource] numberOfRowsInTableView:tableView];
    CGFloat multiplier  = (rows > rowsLimit) ? rowsLimit : rows;
    CGFloat rowHeight   = tableView.rowHeight + 2;
    
    CGFloat newHeight   = rowHeight * multiplier + BUFFER;
    
    if (!heightConstraint) {
        NSPredicate * findHeightConstraint = [NSPredicate predicateWithFormat:@"firstAttribute = %d", NSLayoutAttributeHeight];
        heightConstraint = [[self.constraints filteredArrayUsingPredicate:findHeightConstraint] firstObject];
    }
    heightConstraint.constant = newHeight;
}

@end
