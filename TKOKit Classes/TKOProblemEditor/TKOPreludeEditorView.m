//
//  TKOPreludeEditorView.m
//  ProblemEditor
//
//  Created by Todd Olsen on 6/9/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOPreludeEditorView.h"

@implementation TKOPreludeEditorView

- (instancetype)init
{
    return [super initWithPlaceholder:@"Enter Prelude"];
}

- (void)updateHtmlWithString:(NSString *)string
{
    self.html = [NSString stringWithFormat:@"<p class='prelude'>%@</p>", string];
}

- (NSImage *)image
{
    static NSImage * image = nil;
    if (!image) image = [NSImage imageNamed:NSImageNameHomeTemplate];
    
    return image;
}

- (NSString *)title
{
    return @"Foreword";
}

@end
