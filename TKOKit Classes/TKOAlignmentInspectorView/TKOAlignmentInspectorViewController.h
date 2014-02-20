//
//  TKOAlignmentInspectorViewController.h
//  TKOAlignmentInspectorViewDemo
//
//  Created by Todd Olsen on 2/11/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TKOTextView;

@interface TKOAlignmentInspectorViewController : NSViewController
@property (strong, nonatomic) TKOTextView * textView;
- (id)initWithTextView:(TKOTextView *)textView;
- (void)textViewDidChangeAlignment:(NSNotification *)notification;

@end
