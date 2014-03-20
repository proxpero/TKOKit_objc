//
//  TKOMultipleChoiceAnswerView.m
//  TKOMultipleChoiceAnswerViewDemo
//
//  Created by Todd Olsen on 3/19/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOMultipleChoiceAnswerView.h"
#import "TKOTextTabControl.h"
#import "NSView+TKOKit.h"

@interface TKOMultipleChoiceAnswerView () <TKOTabControlDataSource>

@property (strong, nonatomic) NSTextField * titleField;
@property (strong, nonatomic) TKOTextTabControl * tabControl;

@end

@implementation TKOMultipleChoiceAnswerView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self configureSubviews];
    
    return self;
}

- (void)configureSubviews
{
    static BOOL configured = NO;
    if (configured)
        return;
    
    _titleField = [NSView viewWithClass:[NSTextField class]];
    _titleField.font = [NSFont boldSystemFontOfSize:13];
    _titleField.textColor = [NSColor darkGrayColor];
    _titleField.editable = NO;
    _titleField.bordered = NO;
    _titleField.selectable = NO;
    _titleField.drawsBackground = NO;
    
    [self addSubview:_titleField];
    
    _tabControl = [NSView viewWithClass:[TKOTextTabControl class]];
    _tabControl.dataSource = self;
    
    [self addSubview:_tabControl];
    
    // Constraints...
    
}

- (void)setDataSource:(id<TKOMultipleChoiceAnswerDataSource>)dataSource
{
    if (_dataSource == dataSource)
        return;

    _dataSource = dataSource;
    [self.tabControl reloadData];
}

# pragma mark - Selection

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    self.tabControl.selectedIndex = selectedIndex;
}

- (NSUInteger)selectedIndex
{
    return self.tabControl.selectedIndex;
}

# pragma mark - TKOTabControl Data Source

- (NSUInteger)tabControlNumberOfTabs:(TKOTabControl *)tabControl
{
    return [self.dataSource multipleChoiceViewNumberOfChoices:self];
}

- (NSString *)tabControl:(TKOTabControl *)tabControl
            titleForItem:(id)item
{
    return item;
}

- (id)tabControl:(TKOTabControl *)tabControl
     itemAtIndex:(NSUInteger)index
{
    return [self.dataSource multipleChoiceView:self
                                  titleAtIndex:index];
}

@end
