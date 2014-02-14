//
//  TKOSpacingInspectorViewController.h
//  TKOSpacingInspectorDemo
//
//  Created by Todd Olsen on 2/13/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TKODisclosingViewController.h"

@interface TKOSpacingInspectorViewController : TKODisclosingViewController
- (void)textViewDidChangeSpacing:(NSNotification *)notification;
@end
