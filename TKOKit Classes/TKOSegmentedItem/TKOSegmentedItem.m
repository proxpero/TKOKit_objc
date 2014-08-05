//
//  TKOSegmentedItem.m
//  TKOStackingSidebarDemo
//
//  Created by Todd Olsen on 7/5/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOSegmentedItem.h"

@implementation TKOSegmentedItem


- (instancetype)initWithLabel:(NSString *)label image:(NSImage *)image tag:(NSInteger)tag
{
    self = [super init]; if (!self) return nil;
    
    _label = label;
    _image = image;
    _tag   = tag;
    
    return self;
}


@end
