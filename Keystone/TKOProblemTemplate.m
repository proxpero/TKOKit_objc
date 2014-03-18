//
//  TKOProblemTemplate.m
//  TKOProblemTemplateDemo
//
//  Created by Todd Olsen on 3/13/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOProblemTemplate.h"

@interface TKOProblemTemplate ()

@property (strong, nonatomic) NSMutableDictionary * customAttributes;

@end

@implementation TKOProblemTemplate

- (id)initWithName:(NSString *)name
        attributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self)
        return nil;
    
    _name           = name;
    _attributes     = attributes;
    
    _customAttributes                               = [NSMutableDictionary new];
    _customAttributes[@"TKOProblemTemplateName"]    = _name;
    
    return self;
}

- (NSTextList *)choicesList
{
    NSParagraphStyle * ps = [self.attributes objectForKey:NSParagraphStyleAttributeName];
    return ps.textLists.firstObject;
}

- (NSDictionary *)attributes
{
    NSMutableDictionary * attributes = [NSMutableDictionary new];
    [attributes addEntriesFromDictionary:_attributes];
    [attributes addEntriesFromDictionary:self.customAttributes];
    return attributes;
}

@end
