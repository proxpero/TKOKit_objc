//
//  TKOParagraphStylePickerViewController.h
//  TKOParagraphStylePickerViewDemo
//
//  Created by Todd Olsen on 2/17/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TKOTextView;

@interface TKOParagraphStylePickerViewController : NSViewController
@property (strong, nonatomic) TKOTextView * textView;
- (id)initWithTextView:(TKOTextView *)textView;

@end
