//
//  NSScrollView+TKOKit.m
//  TKOResizingScrollViewDemo
//
//  Created by Todd Olsen on 2/28/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#define BUFFER 2
#define MAX_TALL 10

#import "NSScrollView+TKOKit.h"

@implementation NSScrollView (TKOKit)

- (void)updateHeight
{
    if (![self.documentView isKindOfClass:[NSTableView class]])
        return;
    
    NSTableView * tableView = self.documentView;
    
    if (![[tableView dataSource] respondsToSelector:@selector(numberOfRowsInTableView:)])
        return;

    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d", NSLayoutAttributeHeight];
    NSLayoutConstraint * heightConstraint = [[self.constraints filteredArrayUsingPredicate:predicate] firstObject];
    
    CGFloat height = 0.0;
    NSInteger rows = [[tableView dataSource] numberOfRowsInTableView:tableView];
    
    height = [tableView rowHeight] + 2;
    height = (rows > MAX_TALL) ? height * MAX_TALL : height * rows;
    height += BUFFER;
   
    heightConstraint.constant = height;
}

@end
