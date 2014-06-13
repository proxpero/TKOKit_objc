//
//  TKORomanEditorView.m
//  ProblemEditor
//
//  Created by Todd Olsen on 6/9/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKORomanEditorView.h"

@implementation TKORomanEditorView

- (instancetype)initWithCount:(NSUInteger)count
{
    self = [super initWithPlaceholder:@"Enter Roman Item"
                                count:count
                         markerFormat:@"%@."
                         markerIndent:72];
    
    if (!self) return nil;
    
    self.bullets = @[@"I", @"II", @"III", @"IV", @"V", @"VI", @"VII", @"VIII", @"IX", @"X"];
    
    [self layoutItems];
    
    return self;
}

- (void)updateHtmlWithString:(NSString *)string
{
    self.html = [NSString stringWithFormat:@"<ol class='roman'>\n%@</ol><!-- roman -->\n", string];
}
@end