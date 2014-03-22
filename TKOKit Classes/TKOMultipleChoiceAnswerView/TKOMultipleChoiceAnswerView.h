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
@optional

- (NSFont *)fontForMultipleChoiceAnswerView:(TKOMultipleChoiceAnswerView *)multipleChoiceAnswerView;
- (NSColor *)backgroundColorForMultipleChoiceAnswerView:(TKOMultipleChoiceAnswerView *)multipleChoiceAnswerView;
- (NSColor *)backgroundHighlightColorForMultipleChoiceAnswerView:(TKOMultipleChoiceAnswerView *)multipleChoiceAnswerView;
- (NSColor *)borderColorForMultipleChoiceAnswerView:(TKOMultipleChoiceAnswerView *)multipleChoiceAnswerView;
- (NSColor *)borderHighlightColorForMultipleChoiceAnswerView:(TKOMultipleChoiceAnswerView *)multipleChoiceAnswerView;
- (NSColor *)textColorForMultipleChoiceAnswerView:(TKOMultipleChoiceAnswerView *)multipleChoiceAnswerView;
- (NSColor *)textHighlightColorForMultipleChoiceAnswerView:(TKOMultipleChoiceAnswerView *)multipleChoiceAnswerView;

@end

struct {
    unsigned int fontForMultipleChoiceAnswerView:1;
    unsigned int backgroundColorForMultipleChoiceAnswerView:1;
    unsigned int backgroundHighlightColorForMultipleChoiceAnswerView:1;
    unsigned int borderColorForMultipleChoiceAnswerView:1;
    unsigned int borderHighlightColorForMultipleChoiceAnswerView:1;
    unsigned int textColorForMultipleChoiceAnswerView:1;
    unsigned int textHighlightColorForMultipleChoiceAnswerView:1;
} multipleChoiceAnswerDataSourceRespondsTo;

@interface TKOMultipleChoiceAnswerView : NSView

@property (weak, nonatomic) id <TKOMultipleChoiceAnswerDataSource> dataSource;
@property (nonatomic) NSUInteger selectedIndex;

- (void)reloadData;
- (void)configureSubviews;

@end

@interface TKOMCButton : NSControl

@property (strong, nonatomic) NSTextField * textField;

@property (nonatomic) NSInteger state;
@property (copy, nonatomic) NSColor * titleTextColor;
@property (copy, nonatomic) NSColor * titleTextHighlightColor;
@property (copy, nonatomic) NSColor * backgroundColor;
@property (copy, nonatomic) NSColor * backgroundHighlightColor;
@property (copy, nonatomic) NSColor * borderColor;
@property (copy, nonatomic) NSColor * borderHighlightColor;

@end
