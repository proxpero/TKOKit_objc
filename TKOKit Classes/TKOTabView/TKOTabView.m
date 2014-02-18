//
//  TKOTabView.m
//  TKOTabViewDemo
//
//  Created by Todd Olsen on 2/18/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOTabView.h"
#import "TKOHeaderCell.h"

@interface TKOTabView () <TKOTabControlDataSource>

@property (strong, nonatomic) TKOTextTabControl * tabControl;
@property (strong, nonatomic) NSArray * tabViews;

@end


@implementation TKOTabView


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self setupSubViews];
    }
    return self;
}


- (void)awakeFromNib
{
    [self setupSubViews];
}


- (void)setupSubViews
{
    _tabControl = [[TKOTextTabControl alloc] init];
    [_tabControl.cell setBorderMask:TKOBorderMaskBottom];
    [_tabControl setDataSource:self];
    
    [self addSubview:_tabControl];
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tabControl]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_tabControl)]];
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tabControl]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_tabControl)]];
}

# pragma mark - Tab Control Data Source

- (NSUInteger)tabControlNumberOfTabs:(TKOTabControl *)tabControl
{
    return self.tabViews.count;
}

- (id)tabControl:(TKOTabControl *)tabControl
     itemAtIndex:(NSUInteger)index
{
    return self.tabViews[index];
}

- (NSString *)tabControl:(TKOTabControl *)tabControl
            titleForItem:(id)item
{
    return [item description];
}

@end
