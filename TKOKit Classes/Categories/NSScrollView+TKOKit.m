//
//  NSScrollView+TKOKit.m
//  TKOResizingScrollViewDemo
//
//  Created by Todd Olsen on 2/28/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#define BUFFER 2

#import "NSScrollView+TKOKit.h"
#import <objc/runtime.h>

static char const * const TKODynamicScrollViewUpdatesHeightKey    = "TKODynamicScrollViewUpdatesHeightKey";
static char const * const TKODynamicScrollViewMaxVisibleRowsKey   = "TKODynamicScrollViewMaxVisibleRowsKey";
static char const * const TKODynamicScrollViewHeightConstraintKey = "TKODynamicScrollViewHeightConstraintKey";

@implementation NSScrollView (TKOKit)

- (void)setUpdatesHeight:(BOOL)updatesHeight
{
    objc_setAssociatedObject(self, TKODynamicScrollViewUpdatesHeightKey, @(updatesHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)updatesHeight
{
    return [objc_getAssociatedObject(self, TKODynamicScrollViewUpdatesHeightKey) boolValue];
}

- (void)setMaximumVisibleRows:(NSInteger)maximumVisibleRows
{
    objc_setAssociatedObject(self, TKODynamicScrollViewMaxVisibleRowsKey, @(maximumVisibleRows), OBJC_ASSOCIATION_RETAIN);
}

- (NSInteger)maximumVisibleRows
{
    NSNumber * max = objc_getAssociatedObject(self, TKODynamicScrollViewMaxVisibleRowsKey);
    return (max != nil) ? [max integerValue] : NSIntegerMax;
}

- (void)setHeightConstraint:(NSLayoutConstraint *)heightConstraint
{
    objc_setAssociatedObject(self, TKODynamicScrollViewHeightConstraintKey, heightConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)heightConstraint
{
    NSLayoutConstraint * heightConstraint = objc_getAssociatedObject(self, TKODynamicScrollViewHeightConstraintKey);
    if (!heightConstraint) {
        NSPredicate * findHeightConstraint = [NSPredicate predicateWithFormat:@"firstAttribute = %d", NSLayoutAttributeHeight];
        heightConstraint = [[self.constraints filteredArrayUsingPredicate:findHeightConstraint] firstObject];
        objc_setAssociatedObject(self, TKODynamicScrollViewHeightConstraintKey, heightConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return heightConstraint;
}

- (void)updateHeight
{
    if (!objc_getAssociatedObject(self, TKODynamicScrollViewMaxVisibleRowsKey))
        [self setMaximumVisibleRows:0];
    
    if (![self.documentView isKindOfClass:[NSTableView class]])
        return;
    
    NSTableView * tableView = self.documentView;
    id dataSource = [tableView dataSource];
    
    if (![dataSource respondsToSelector:@selector(numberOfRowsInTableView:)])
        return;
    
    NSInteger rowsLimit = self.maximumVisibleRows;
    
    NSInteger rows = [[tableView dataSource] numberOfRowsInTableView:tableView];
    if (rowsLimit == 0)
        rowsLimit = rows;
    
    CGFloat multiplier  = (rows > rowsLimit) ? rowsLimit : rows;
    CGFloat rowHeight   = tableView.rowHeight + 2;
    
    CGFloat newHeight   = rowHeight * multiplier + BUFFER;
    
    NSLayoutConstraint * heightConstraint = [self heightConstraint];
    heightConstraint.constant = newHeight;
    NSLog(@"newheight=%f", newHeight);
}

@end
