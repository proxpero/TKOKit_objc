//
//  TKOTabView.m
//  TKOInspectorViewControllerDemo
//
//  Created by Todd Olsen on 2/18/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOTabView.h"
#import "TKOTextTabControl.h"
#import "TKOHeaderCell.h"
#import "NSView+TKOKit.h"

@interface TKOTabView () <TKOTabControlDataSource>

@property (strong, nonatomic) TKOTextTabControl * tabControl;
@property (weak, nonatomic) TKOTabViewItem * currentItem;

@end

# pragma mark - TKOTabView Implementation

@implementation TKOTabView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureTabControl];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib]; // [super responds]...?
    [self configureTabControl];
}

- (void)configureTabControl
{
    if (_tabControl)
        return;

    _tabControl = [NSView viewWithClass:[TKOTextTabControl class]];
    
    [self addSubview:_tabControl];
    
    [_tabControl addConstraint:
     [NSLayoutConstraint constraintWithItem:_tabControl
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:28]];
    NSDictionary * views = @{@"_tabControl": _tabControl};
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tabControl]"
                                             options:0
                                             metrics:nil
                                               views:views]];
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tabControl]|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    [_tabControl setDataSource:self];
}

- (void)setTabViewItems:(NSArray *)tabViewItems
{
    if (_tabViewItems == tabViewItems)
        return;
    
    _tabViewItems = tabViewItems;
    [self.tabControl reloadData];
}

# pragma mark - Tab Control Data Source

- (NSUInteger)tabControlNumberOfTabs:(TKOTabControl *)tabControl
{
    return self.tabViewItems.count;
}

- (id)tabControl:(TKOTabControl *)tabControl
     itemAtIndex:(NSUInteger)index
{
    return self.tabViewItems[index];
}

- (NSString *)tabControl:(TKOTabControl *)tabControl
            titleForItem:(id)item
{
    return [item title];
}

- (void)tabControlDidChangeSelection:(NSNotification *)notification
{
    [_currentItem.view removeFromSuperview];
    _currentItem = [self.tabControl selectedItem];
    NSView * subview = _currentItem.view;
    [self addSubview:subview];
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_tabControl][subview]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_tabControl, subview)]];
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subview]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(subview)]];
}

@end

# pragma mark - TKOTabViewItem Implementation

@implementation TKOTabViewItem

+ (instancetype)itemWithView:(NSView *)view
                       title:(NSString *)title
{
    TKOTabViewItem * item = [[self alloc] init];
    [item setView:view];
    [item setTitle:title];
    return item;
}

@end
