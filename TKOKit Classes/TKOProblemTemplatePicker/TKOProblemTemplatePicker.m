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

@end

@implementation TKOProblemTemplatePicker
{
    NSInteger _rows;
}

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
    
    _scrollView.updatesHeight = YES;
    
    return self;
}



- (IBAction)addItem:(id)sender
{
    [self.scrollView updateHeight];
}

- (IBAction)removeItem:(id)sender
{
    [self.scrollView updateHeight];
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

@end
