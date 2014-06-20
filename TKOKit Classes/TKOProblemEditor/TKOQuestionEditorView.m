//
//  TKOQuestionEditorView.m
//  ProblemEditor
//
//  Created by Todd Olsen on 6/9/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOQuestionEditorView.h"

@implementation TKOQuestionEditorView

- (instancetype)init
{
    return [super initWithPlaceholder:@"Enter Question"];
}

- (void)updateHtmlWithString:(NSString *)string
{
    self.html = [NSString stringWithFormat:@"<p class='question'>%@</p>", string];
}

- (NSImage *)image
{
    static NSImage * image = nil;
    if (!image) image = [NSImage imageNamed:NSImageNameActionTemplate];
    
    return image;
}

- (NSString *)title
{
    return @"Question";
}

@end
