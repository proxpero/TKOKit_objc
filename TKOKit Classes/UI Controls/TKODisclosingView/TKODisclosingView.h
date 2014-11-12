//
//  TKODisclosingView.h
//
//  Created by Todd Olsen on 3/5/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

@import Cocoa;

@interface TKODisclosingView : NSView

@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSView * contentView;
@property (strong, nonatomic) NSView * accessoryView;

- (id)initWithTitle:(NSString *)title
        contentView:(NSView *)contentView;

- (id)initWithTitle:(NSString *)title
        contentView:(NSView *)contentView
      accessoryView:(NSView *)accessoryView;

@end
