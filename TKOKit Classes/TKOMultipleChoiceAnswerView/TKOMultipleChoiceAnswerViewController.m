//
//  TKOMultipleChoiceAnswerViewController.m
//  TKOMultipleChoiceAnswerViewDemo
//
//  Created by Todd Olsen on 3/19/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOMultipleChoiceAnswerViewController.h"
#import "TKOTextTabControl.h"

@interface TKOMultipleChoiceAnswerViewController () <TKOTabControlDataSource>

@property (strong) IBOutlet TKOTextTabControl *tabControl;

@end

@implementation TKOMultipleChoiceAnswerViewController
{
    NSArray * _letters;
}

- (id)init
{
    self = [super initWithNibName:@"TKOMultipleChoiceAnswerViewController"
                           bundle:nil];
    if (!self)
        return nil;
    
    _letters = @[@"A", @"B", @"C", @"D", @"E"];
    
    return self;
}

- (void)awakeFromNib
{
    self.tabControl.dataSource = self;
    self.tabControl.borderMask = TKOBorderMaskBottom|TKOBorderMaskTop|TKOBorderMaskLeft|TKOBorderMaskRight;
}

- (TKOBorderMask)tabControl:(TKOTabControl *)tabControl
   borderMaskForItemAtIndex:(NSUInteger)index
{
    TKOBorderMask borderMask = TKOBorderMaskLeft|TKOBorderMaskTop|TKOBorderMaskBottom;
    borderMask = (index < _letters.count - 1) ? borderMask : borderMask|TKOBorderMaskRight;
    return borderMask;
}

- (NSFont *)fontForTabControl:(TKOTabControl *)tabControl
{
    return [NSFont systemFontOfSize:13.0];
}

- (NSUInteger)tabControlNumberOfTabs:(TKOTabControl *)tabControl
{
    return _letters.count;
}

- (id)tabControl:(TKOTabControl *)tabControl itemAtIndex:(NSUInteger)index
{
    return _letters[index];
}

- (NSString *)tabControl:(TKOTabControl *)tabControl titleForItem:(id)item
{
    return item;
}

@end
