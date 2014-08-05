//
//  TKONewSidebarView.m
//  TKOSidebarDemo
//
//  Created by Todd Olsen on 6/26/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKONewSidebarView.h"

@interface TKONewSidebarView ()

@property (nonatomic) NSStackView * buttonStackView;
@property (nonatomic) NSUInteger selectedIndex;

@end

@implementation TKONewSidebarView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (!self) return nil;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    return self;
}




- (void)configureButtons
{
    
}

@end
