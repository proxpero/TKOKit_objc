//
//  TKOComponentFlowDelegate.h
//  ProblemEditor
//
//  Created by Todd Olsen on 6/9/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TKOComponentFlowDelegate <NSObject>

- (BOOL)componentShouldGoUp:(id)componentView;
- (BOOL)componentShouldGoDown:(id)componentView;

@optional
- (NSResponder *)topResponder;
- (NSResponder *)bottomResponder;

@end
