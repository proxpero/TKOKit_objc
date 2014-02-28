//
//  TKOTableViewDelegate.m
//  TKOResizingScrollViewDemo
//
//  Created by Todd Olsen on 2/28/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOTableViewDelegate.h"
#import "NSScrollView+TKOKit.h"
#import "NSTableView+TKOKit.h"

@implementation TKOTableViewDelegate

- (void)setRows:(NSInteger)rows
{
    if (_rows == rows)
        return;

    _rows = rows;
    [self.tableView reloadData];
    [[self.tableView enclosingScrollView] updateHeight]; // -updateHeight is a custom catagory on NSScrollView
    [self updateUI];
}

- (void)setVisibleRows:(NSInteger)visibleRows
{
    if (_visibleRows == visibleRows)
        return;
    
    _visibleRows = visibleRows;
    [[self.tableView enclosingScrollView] updateHeight]; // -updateHeight is a custom catagory on NSScrollView
    [self updateUI];
}

- (void)updateUI
{
    if (self.rows > self.visibleRows) {
        self.textColor = [NSColor redColor];
        [self.tableView scrollToEndOfDocument:self];
    } else {
        self.textColor = [NSColor blackColor];
    }
}

# pragma mark - NSTableView Delegate and Data Source Protocols

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row
{
    NSTableCellView * result = [tableView makeViewWithIdentifier:@"MyCell"
                                                           owner:self];
    result.textField.stringValue = [NSString stringWithFormat:@"row %lu", row + 1];
    return result;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return _rows;
}

//- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row { return nil; }

# pragma mark - TKODynamicTableViewDataSource Protocol

// If this method is not implemented, the maximum visible rows will be NSIntegerMax. If it returns a negative number, max is 0;
- (NSInteger)maximumNumberOfVisibleRowsInTableView:(NSTableView *)tableView // in NSTableView+TKOKit: inherits from NSTableViewDataSource
{
    return self.visibleRows;
}

# pragma mark - UI Actions

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
