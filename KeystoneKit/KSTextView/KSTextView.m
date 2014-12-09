//
//  KSTextView.m
//  Keystone-Mac
//
//  Created by Todd Olsen on 12/7/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "KSTextView.h"


@implementation KSTextView


- (BOOL)becomeFirstResponder
{
    BOOL flag = [super becomeFirstResponder];
    
    if (flag) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KSTextViewDidBecomeFirstResponderNotification
                                                            object:self];
    }
    
    return flag;
}


- (BOOL)resignFirstResponder
{
    BOOL flag = [super resignFirstResponder];
    
    if (flag) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KSTextViewDidResignFirstResponderNotification
                                                            object:self];
    }
    
    return flag;
}


@end

NSString * const KSTextViewDidBecomeFirstResponderNotification = @"KSTextViewDidBecomeFirstResponderNotification";
NSString * const KSTextViewDidResignFirstResponderNotification = @"KSTextViewDidResignFirstResponderNotification";
