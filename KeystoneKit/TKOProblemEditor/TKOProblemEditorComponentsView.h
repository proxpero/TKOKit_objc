//
//  TKOProblemComponentsView.h
//  Keystone
//
//  Created by Todd Olsen on 5/30/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TKOProblemEditorComponentsView : NSStackView

@property (nonatomic) NSString * html;

//- (NSView *)initialResponder;

- (void)setComponents:(NSArray *)components;
- (void)addComponent:(NSView *)component;
- (void)insertComponent:(NSView *)component atIndex:(NSUInteger)index;
- (void)removeComponent:(NSView *)component;

@end
