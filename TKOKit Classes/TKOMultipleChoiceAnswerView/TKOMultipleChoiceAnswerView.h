//
//  TKOMultipleChoiceAnswerView.h
//  TKOMultipleChoiceAnswerViewDemo
//
//  Created by Todd Olsen on 3/19/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TKOMultipleChoiceAnswerView;

@protocol TKOMultipleChoiceAnswerDataSource <NSObject>

- (NSUInteger)multipleChoiceViewNumberOfChoices:(TKOMultipleChoiceAnswerView *)multipleChoiceView;
- (NSString *)multipleChoiceView:(TKOMultipleChoiceAnswerView *)multipleChoiceView
                    titleAtIndex:(NSUInteger)index;

@end

@interface TKOMultipleChoiceAnswerView : NSView

@property (weak, nonatomic) id <TKOMultipleChoiceAnswerDataSource> dataSource;
@property (nonatomic) NSUInteger selectedIndex;

- (void)reloadData;
- (void)configureSubviews;

@end
