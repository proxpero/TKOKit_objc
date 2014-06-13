//
//  TKOProblemEditorTextView.h
//  ProblemEditor
//
//  Created by Todd Olsen on 6/6/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TKOProblemEditorTextView;

@interface TKOProblemEditorTextView : NSTextView

- (instancetype)initWithPlaceholder:(NSString *)placeholder;

@end