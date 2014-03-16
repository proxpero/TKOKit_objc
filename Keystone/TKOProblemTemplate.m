//
//  TKOProblemTemplate.m
//  TKOProblemTemplateDemo
//
//  Created by Todd Olsen on 3/13/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOProblemTemplate.h"

@implementation TKOProblemTemplate

- (NSDictionary *)attributes
{
    return @{NSParagraphStyleAttributeName: self.paragraphStyle,
             @"TKOProblemTemplateStyleAttributeName": self.name
             };
    NSLog(@"%@", NSParagraphStyleAttributeName);
}

@end
