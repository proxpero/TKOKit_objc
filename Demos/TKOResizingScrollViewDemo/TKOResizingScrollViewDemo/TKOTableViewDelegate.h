//
//  TKOTableViewDelegate.h
//  TKOResizingScrollViewDemo
//
//  Created by Todd Olsen on 2/28/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKOTableViewDelegate : NSObject <NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic) NSInteger rows;
@property (strong) IBOutlet NSTableView *tableView;

- (IBAction)addRow:(id)sender;
- (IBAction)removeRow:(id)sender;

@end
