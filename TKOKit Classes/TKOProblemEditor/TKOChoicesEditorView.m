//
//  TKOChoicesEditorView.m
//  ProblemEditor
//
//  Created by Todd Olsen on 6/9/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOChoicesEditorView.h"

@implementation TKOChoicesEditorView

- (instancetype)initWithCount:(NSUInteger)count
{
    self = [super initWithPlaceholder:@"Enter Answer Choice"
                                count:count
                         markerFormat:@"(%@)"
                         markerIndent:54];
    if (!self) return nil;
    
    self.bullets = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J"];
    
    [self layoutItems];
    
    return self;
}

- (void)updateHtmlWithString:(NSString *)string
{
    self.html = [NSString stringWithFormat:@"<ol class='choices'>\n%@</ol><!-- choices -->\n", string];
}

@end
