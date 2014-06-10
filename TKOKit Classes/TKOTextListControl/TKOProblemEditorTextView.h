//
//  TKOProblemEditorTextView.h
//  ProblemEditor
//
//  Created by Todd Olsen on 6/6/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TKOComponentFlowDelegate.h"

@class TKOProblemEditorTextView;

extern NSString * TKOTextGoForwardKeyNotification;
extern NSString * TKOTextGoBackwardKeyNotification;
extern NSString * TKOTextNewlineKeyNotification;
extern NSString * TKOTextTabKeyNotification;
extern NSString * TKOTextDeleteKeyNotification;

@interface TKOProblemEditorTextView : NSTextView

@property (nonatomic) NSSize textInset;
@property (nonatomic) CGFloat singleLineHeight;
@property (nonatomic) id <TKOComponentFlowDelegate> flowDelegate;

- (instancetype)initWithFont:(NSFont *)font
                 placeholder:(NSString *)placeholder
                   textInset:(NSSize)textInset;

@end