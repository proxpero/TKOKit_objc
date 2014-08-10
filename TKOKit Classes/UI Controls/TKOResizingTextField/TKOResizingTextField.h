//
//  TKOResizingTextField.h
//  TKOResizingTextFieldDemo
//
//  Created by Todd Olsen on 7/10/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TKOResizingTextField : NSTextField

@property (nonatomic, strong) IBOutlet NSLayoutConstraint * heightConstraint;

@end
