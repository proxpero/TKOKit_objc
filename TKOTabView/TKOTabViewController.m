//
//  TKOTabViewController.m
//  TKOTabViewDemo
//
//  Created by Todd Olsen on 2/18/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOTabViewController.h"
#import "TKOTextTabControl.h"
#import "TKOHeaderCell.h"

@interface TKOTabViewController () <TKOTabControlDataSource>
@property (weak) IBOutlet TKOTextTabControl *tabControl;

@property (weak, nonatomic) NSView * currentView;

@end

@implementation TKOTabViewController

- (id)init
{
    self = [self initWithNibName:@"TKOTabViewController"
                          bundle:nil];
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        [self.tabControl setDataSource:self];
        [self.tabControl.cell setBorderMask:TKOBorderMaskBottom];
    
    }
    return self;
}

- (void)awakeFromNib
{
    [self.tabControl setDataSource:self];
    [self.tabControl.cell setBorderMask:TKOBorderMaskBottom];
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
    [self.view addSubview:_currentView];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_tabControl][_currentView]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_tabControl, _currentView)]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_currentView]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_currentView)]];
}

@end
