//
//  TKOComponentEditorListView.h
//  ProblemEditor
//
//  Created by Todd Olsen on 6/12/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TKOComponentView.h"

@interface TKOComponentEditorListView : NSView <TKOComponentView>

@property (nonatomic) NSString * html;
@property (nonatomic) NSArray  * bullets;
@property (nonatomic) NSString * formatMarker;

- (instancetype)initWithPlaceholder:(NSString *)placeholder
                              count:(NSUInteger)count
                       markerFormat:(NSString *)markerFormat
                       markerIndent:(CGFloat)markerIndent;
- (void)layoutItems;
- (NSImage *)image;
- (NSString *)title;

@end

@class TKOProblemEditorTextView;
@interface TKOListItemView : NSView

@property (nonatomic) NSTextField * label;
@property (nonatomic) TKOProblemEditorTextView * textView;

+ (instancetype)itemWithPlaceholder:(NSString *)placeholder
                               font:(NSFont *)font
                         itemIndent:(CGFloat)itemIndent;

@end