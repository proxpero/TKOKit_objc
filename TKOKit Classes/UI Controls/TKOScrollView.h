//
//  TKOScrollView.h
//  Keystone-Mac
//
//  Created by Todd Olsen on 12/4/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TKOScrollView : NSScrollView

@property (nonatomic) BOOL nonScrolling;
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) NSColor * borderColor;

@end
