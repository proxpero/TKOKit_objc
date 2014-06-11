//
//  TKOComponentView.h
//  ProblemEditor
//
//  Created by Todd Olsen on 6/10/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TKOComponentView <NSObject>

- (NSView *)firstKeyView;
- (NSView *)lastKeyView;
- (NSString *)html;

@end
