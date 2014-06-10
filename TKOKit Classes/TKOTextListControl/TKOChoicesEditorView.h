//
//  TKOChoicesEditorView.h
//  ProblemEditor
//
//  Created by Todd Olsen on 6/9/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TKOComponentFlowDelegate.h"

@interface TKOChoicesEditorView : NSView <TKOComponentFlowDelegate>

@property (nonatomic, weak) id <TKOComponentFlowDelegate> flowDelegate;

@end
