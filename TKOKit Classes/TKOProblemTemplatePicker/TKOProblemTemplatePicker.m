//
//  TKOProblemTemplatePicker.m
//  TKOProblemTemplateClassDemo
//
//  Created by Todd Olsen on 3/6/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOProblemTemplatePicker.h"
#import "NSScrollView+TKOKit.h"

@interface TKOProblemTemplatePicker ()

@property (weak) IBOutlet NSScrollView *scrollView;

- (IBAction)addItem:(id)sender;
- (IBAction)removeItem:(id)sender;

@property (strong, nonatomic) NSTableView * tableView;
@property (strong) IBOutlet NSLayoutConstraint *heightConstraint;

@end

@implementation TKOProblemTemplatePicker

- (id)init
{
    return [self initWithNibName:@"TKOProblemTemplatePicker"
                          bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (!self)
        return nil;

    self.rows = 3;
    
    return self;
}

- (void)awakeFromNib
{
    if (!self.tableView)
    {
        self.tableView = _scrollView.documentView;
        [self.tableView reloadData];
        [_scrollView updateHeight];
    }
}

- (void)setRows:(NSInteger)rows
{
    if (_rows == rows)
        return;
    
    _rows = rows;
    [_scrollView.documentView reloadData];
    
//    CGFloat multiplier  = (rows > rowsLimit) ? rowsLimit : rows;
//    CGFloat rowHeight   = self.tableView.rowHeight + 2;
//    
//    CGFloat newHeight   = rowHeight * _rows + 0.0;
//    
//    NSLayoutConstraint * heightConstraint = [self heightConstraint];
//    heightConstraint.constant = newHeight;
    
//    [[self.tableView enclosingScrollView] setUpdatesHeight:YES]; // -setUpdatesHeight: is an Associated Object on NSScrollView+TKOKit
    [self.scrollView updateHeight]; // -updateHeight is a custom catagory on NSScrollView
}

- (IBAction)addItem:(id)sender
{
    [self setRows:_rows + 1];
}

- (IBAction)removeItem:(id)sender
{
    if (_rows < 1)
        return;
    
    [self setRows:_rows - 1];
}

# pragma mark - NSTableView Delegate and Data Source Protocols

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row
{
    NSLog(@"row %lu", row);
    NSTableCellView * result = [tableView makeViewWithIdentifier:@"MyCell"
                                                           owner:self];
    result.textField.stringValue = [NSString stringWithFormat:@"row %lu", row + 1];
    return result;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    NSLog(@"rows: %lu", _rows);
    return _rows;
}

@end
