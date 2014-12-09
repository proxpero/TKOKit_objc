//
//  TKOResizingTableView.m
//  Keystone-Mac
//
//  Created by Todd Olsen on 12/5/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

@import QuartzCore;
#import "TKOResizingTableView.h"

@interface TKOResizingTableView ()



@end

@implementation TKOResizingTableView

- (void)reloadData
{
    [super reloadData];
    [self adjustTableViewHeight];
}

- (void)adjustTableViewHeight
{
    CGFloat rowHeight = self.rowHeight + self.rowHeightOffset;
    CGFloat height = rowHeight * self.numberOfRows;
    if (height < rowHeight) height = rowHeight;
    
    if (!self.scrollViewHeightConstraint) {
        self.scrollViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.superview.superview
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1
                                                                        constant:height + self.tableHeightOffset];
    }

    else {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            self.scrollViewHeightConstraint.animator.constant = height + self.tableHeightOffset;
        } completionHandler:nil];
    }
}

- (BOOL)resignFirstResponder
{
    [self deselectAll:nil];
    return [super resignFirstResponder];
}

@end
