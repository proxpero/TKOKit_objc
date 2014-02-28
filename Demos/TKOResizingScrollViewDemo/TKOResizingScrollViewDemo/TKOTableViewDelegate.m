//
//  TKOTableViewDelegate.m
//  TKOResizingScrollViewDemo
//
//  Created by Todd Olsen on 2/28/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOTableViewDelegate.h"
#import "NSScrollView+TKOKit.h"

@implementation TKOTableViewDelegate

- (void)setRows:(NSInteger)rows
{
    if (_rows == rows)
        return;

    _rows = rows;
    [self.tableView reloadData];
    [[self.tableView enclosingScrollView] updateHeight];
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row
{
    NSTableCellView * result = [tableView makeViewWithIdentifier:@"MyCell"
                                                           owner:self];
    result.textField.stringValue = [NSString stringWithFormat:@"row %lu", row];
    return result;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return _rows;
}

- (id)          tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
                      row:(NSInteger)row
{
    return nil;
}

- (IBAction)addRow:(id)sender
{
    [self setRows:_rows + 1];
}

- (IBAction)removeRow:(id)sender
{
    if (_rows < 1)
        return;
    
    [self setRows:_rows - 1];
}

@end
