//
//  TKOTemplateViewController.h
//  TKOKeystoneProblemEditorDemo
//
//  Created by Todd Olsen on 3/19/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TKOTextView;

@interface TKOTemplateViewController : NSViewController <NSTextViewDelegate, NSTextStorageDelegate>

@property (unsafe_unretained, nonatomic) TKOTextView * textView;

@end
