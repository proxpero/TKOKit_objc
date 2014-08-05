//
//  TKOImageEditorComponentView.h
//  TKOProblemEditorDemo
//
//  Created by Todd Olsen on 6/22/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TKOComponentView.h"

@interface TKOImageEditorComponentView : NSView <TKOComponentView>

- (NSString *)title;
- (NSString *)html;

@end
