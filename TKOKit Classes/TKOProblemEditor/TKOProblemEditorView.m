//
//  TKOProblemEditorView.m
//  TKOProblemEditorDemo
//
//  Created by Todd Olsen on 6/13/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOProblemEditorView.h"
#import "TKOProblemEditorHeaderView.h"
#import "TKOProblemComponentsEditorView.h"

@interface TKOProblemEditorView ()

@property (nonatomic) TKOProblemEditorHeaderView * header;
@property (nonatomic) TKOProblemComponentsEditorView * editor;

@end

@implementation TKOProblemEditorView

- (id)init
{
    self = [super initWithFrame:NSZeroRect];
    if (!self) return nil;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    _header = [[TKOProblemEditorHeaderView alloc] init];
    
    
    return self;
}

@end
