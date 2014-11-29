//
//  TKOTabControl.h
//  Keystone
//
//  Created by Todd Olsen on 12/2/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import "NSView+TKOKit.h"
#import "TKOTabControlDataSource.h"
#import "TKOHeaderCell.h"

//@class VSTheme;

@interface TKOTabControl : NSControl

@property (nonatomic) TKOBorderMask borderMask;
//@property (strong, nonatomic) VSTheme * theme;
@property (nonatomic, strong) NSArray * items;
@property (nonatomic, weak) id selectedItem;
@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic, weak) id <TKOTabControlDataSource> dataSource;

- (void)reloadData;
- (void)selectTab:(id)sender;

@end
