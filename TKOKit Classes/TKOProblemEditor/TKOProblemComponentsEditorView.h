//
//  TKOProblemComponentsEditorView.h
//  ProblemEditor
//
//  Created by Todd Olsen on 5/30/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TKOProblemComponentsEditorView : NSView

@property (nonatomic) NSString * html;
- (NSView *)initialResponder;

@end
