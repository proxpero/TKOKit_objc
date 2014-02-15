//
//  TKOScalingScrollView.h
//  TKOKit
//
//  Created by Todd Olsen on 2/15/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TKOScalingScrollView : NSScrollView

@property (nonatomic) BOOL fitToWidth;
@property (nonatomic) CGFloat documentWidth;
@property (nonatomic) CGFloat documentInset;

- (void)frameDidChange:(NSNotification *)notification;

@end

