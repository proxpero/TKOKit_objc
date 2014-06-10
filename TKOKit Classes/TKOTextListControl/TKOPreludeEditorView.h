//
//  TKOPreludeEditorView.h
//  ProblemEditor
//
//  Created by Todd Olsen on 6/9/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TKOComponentFlowDelegate.h"

@class TKOProblemEditorTextView;

@interface TKOPreludeEditorView : NSView

@property (nonatomic) TKOProblemEditorTextView * textView;

@end
