//
//  TKOResizingTableView.h
//  Keystone-Mac
//
//  Created by Todd Olsen on 12/5/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TKOResizingTableView : NSTableView

@property (nonatomic) BOOL deselectOnResigningFirstResponder;
@property (nonatomic) CGFloat rowHeightOffset;
@property (nonatomic) CGFloat tableHeightOffset;
@property (nonatomic) NSLayoutConstraint * scrollViewHeightConstraint;

- (void)adjustTableViewHeight;

@end
