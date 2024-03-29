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
    [[self.tableView enclosingScrollView] setUpdatesHeight:YES]; // -setUpdatesHeight: is an Associated Object on NSScrollView+TKOKit
    [[self.tableView enclosingScrollView] updateHeight]; // -updateHeight is a custom catagory on NSScrollView
    [self updateUI];
}

- (void)setVisibleRows:(NSInteger)visibleRows
{
    if (_visibleRows == visibleRows)
        return;
    
    _visibleRows = visibleRows;
    [[self.tableView enclosingScrollView] setMaximumVisibleRows:_visibleRows]; // -setMaximumVisibleRows: is an Associated Object on NSScrollView+TKOKit 
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
