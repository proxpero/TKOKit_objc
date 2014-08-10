//
//  TKOListsInspectorViewController.h
//  TKOListAndBulletsInspectorDemo
//
//  Created by Todd Olsen on 2/14/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKODisclosingViewController.h"

@class TKOTextView;

@interface TKOListsInspectorViewController : TKODisclosingViewController
@property (strong, nonatomic) TKOTextView * textView;
//- (id)initWithTextView:(TKOTextView *)textView;
- (void)updateListAttributes:(NSNotification *)notification;

@end
