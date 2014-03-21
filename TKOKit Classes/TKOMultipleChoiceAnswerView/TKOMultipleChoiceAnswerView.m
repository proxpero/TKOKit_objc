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

@property (strong, nonatomic) NSArray * buttons; // redo without tabControl

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
    _titleField.stringValue = @"Answer"; // Localize!!
    
    
    
    
    _tabControl = [NSView viewWithClass:[TKOTextTabControl class]];

    [self setSubviews:@[ _titleField, _tabControl ]];

    NSString * horizontalConstrainFormat = @"V:|-(13)-[_titleField(==17)]-(11)-[_tabControl(==36)]-(15)-|";
    NSDictionary * views = NSDictionaryOfVariableBindings(_titleField, _tabControl);
    
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:horizontalConstrainFormat
                                             options:0
                                             metrics:nil
                                               views:views]
     ];
    
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:_titleField
                                  attribute:NSLayoutAttributeLeading
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeLeading
                                 multiplier:1
                                   constant:15.0]
     ];
    
    [self addConstraint: // Align Leading Edge
     [NSLayoutConstraint constraintWithItem:_tabControl
                                  attribute:NSLayoutAttributeLeading
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:_titleField
                                  attribute:NSLayoutAttributeLeading
                                 multiplier:1
                                   constant:0]
     ];
    
    [self addConstraint: // Trailing Edge
     [NSLayoutConstraint constraintWithItem:self
                                  attribute:NSLayoutAttributeTrailing
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:_tabControl
                                  attribute:NSLayoutAttributeTrailing
                                 multiplier:1
                                   constant:15]
     ];
    
    _tabControl.dataSource = self;
    configured = YES;
}

- (void)setDataSource:(id<TKOMultipleChoiceAnswerDataSource>)dataSource
{
    if (_dataSource == dataSource)
        return;
    _dataSource = dataSource;
    [self reloadData];
}

- (void)reloadData
{
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
