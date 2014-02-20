//
//  TKOFontInspectorViewController.h
//  TKOFontInspectorViewDemo
//
//  Created by Todd Olsen on 2/8/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TKOTextView;

@interface TKOFontInspectorViewController : NSViewController
@property (strong, nonatomic) TKOTextView * textView;
- (id)initWithTextView:(TKOTextView *)textView;
- (void)textViewDidChangeFont:(NSNotification *)notification;

@end
