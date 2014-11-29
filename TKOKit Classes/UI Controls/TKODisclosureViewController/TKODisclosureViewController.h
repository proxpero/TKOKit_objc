//
//  TKODisclosureViewController.h
//
//  Created by Todd Olsen on 11/6/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

@import Cocoa;

@interface TKODisclosureViewController : NSViewController

@property (nonatomic) NSViewController * contentViewController;
@property (nonatomic, copy) NSString * label;
@property (nonatomic, copy) NSString * accessoryLabel;
@property (strong, nonatomic) NSView * contentView;

+ (instancetype)newWithViewController:(NSViewController *)viewController;

@end
