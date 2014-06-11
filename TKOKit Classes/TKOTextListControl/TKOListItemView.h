//
//  TKOListItemView.h
//  ProblemEditor
//
//  Created by Todd Olsen on 6/9/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TKOProblemEditorTextView;
@class TKOListItemMetricsHelper;

@interface TKOListItemView : NSView

@property (nonatomic) NSTextField * label;
@property (nonatomic) TKOProblemEditorTextView * textView;

+ (instancetype)itemWithMetrics:(TKOListItemMetricsHelper *)metrics;

@end

@interface TKOListItemMetricsHelper : NSObject

@property (nonatomic) NSString * placeholder;
@property (nonatomic) NSFont * font;
@property (nonatomic) CGFloat widthOffset;
@property (nonatomic) CGFloat heightOffset;
@property (nonatomic) CGFloat itemIndent;

- (instancetype)initWithPlaceholder:(NSString *)placeholder
                               font:(NSFont *)font
                        widthOffset:(CGFloat)widthOffset
                       heightOffset:(CGFloat)heightOffset
                         itemIndent:(CGFloat)itemIndent;

@end