//
//  TKOQuestionEditorView.h
//  ProblemEditor
//
//  Created by Todd Olsen on 6/9/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TKOComponentFlowDelegate.h"

@class TKOProblemEditorTextView;

@interface TKOQuestionEditorView : NSView <TKOComponentFlowDelegate>

@property (nonatomic) TKOProblemEditorTextView * textView;
@property (nonatomic, weak) id <TKOComponentFlowDelegate> flowDelegate;

@end
