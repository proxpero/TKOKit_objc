//
//  TKOFontInspectorViewController.h
//  TKOFontInspectorViewDemo
//
//  Created by Todd Olsen on 2/8/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TKOFontInspection.h"
#import "TKOTextView.h"

@interface TKOFontInspectorViewController : NSViewController <NSTextDelegate, NSTextViewDelegate, TKOTextViewFontDelegate>

@property (unsafe_unretained, nonatomic) TKOTextView * textView;
@property (unsafe_unretained, nonatomic) id <TKOFontInspectorDelegate> delegate;

@end
