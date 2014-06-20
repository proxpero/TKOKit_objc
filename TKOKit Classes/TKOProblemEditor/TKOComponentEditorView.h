//
//  TKOComponentEditorView.h
//  ProblemEditor
//
//  Created by Todd Olsen on 6/11/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TKOComponentView.h"

@interface TKOComponentEditorView : NSView <TKOComponentView>
@property (nonatomic) NSString * html;

- (instancetype)initWithPlaceholder:(NSString *)placeholder;

- (NSString *)title;
- (NSImage *)image;

@end
