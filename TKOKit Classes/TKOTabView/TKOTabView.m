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
@property (weak, nonatomic) NSView * currentView;

@end

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
    if ([super respondsToSelector:@selector(awakeFromNib)]) {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [super awakeFromNib];
    }
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

- (void)setTabViewControllers:(NSArray *)tabViewControllers
{
    if (_tabViewControllers == tabViewControllers)
        return;
    
    _tabViewControllers = tabViewControllers;
    [self.tabControl reloadData];
}

# pragma mark - Tab Control Data Source

- (NSUInteger)tabControlNumberOfTabs:(TKOTabControl *)tabControl
{
    return self.tabViewControllers.count;
}

- (id)tabControl:(TKOTabControl *)tabControl
     itemAtIndex:(NSUInteger)index
{
    return self.tabViewControllers[index];
}

- (NSString *)tabControl:(TKOTabControl *)tabControl
            titleForItem:(id)item
{
    return [item title];
}

- (void)tabControlDidChangeSelection:(NSNotification *)notification
{
    [_currentView removeFromSuperview];
    NSViewController * vc = [self.tabControl selectedItem];
    _currentView = vc.view;
    [self addSubview:_currentView];
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_tabControl][_currentView]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_tabControl, _currentView)]];
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_currentView]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_currentView)]];
}

@end
