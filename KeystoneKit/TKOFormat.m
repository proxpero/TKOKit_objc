//
//  TKOFormat.m
//  TKOKeystonePlistDemo
//
//  Created by Todd Olsen on 3/23/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOFormat.h"
#import "TKOProblem.h"

static NSCache * formats = nil;

@implementation TKOFormat

+ (void)initialize
{
    if (!formats) formats = [NSCache new];
}

# pragma mark - Class API

+ (instancetype)formatForIdentifier:(NSString *)identifier
{
    TKOFormat * format = nil;
    format = [formats objectForKey:identifier];
    if (format) return format;
    
    
    
    return format;
}

# pragma mark - Property List Serialization

- (instancetype)initWithPropertyListRepresentation:(id)plist
{
    self = [super initWithPropertyListRepresentation:plist];
    
    id directions = plist[TKODirectionsKey];
    id duration = plist[TKODurationKey];
    id problemIdentifiers = plist[TKOProblemsKey];

    _directions = [directions isKindOfClass:[NSAttributedString class]] ? directions : nil;
    _duration = duration ? [duration integerValue] : NSNotFound;
    if (problemIdentifiers && [problemIdentifiers isKindOfClass:[NSArray class]] && [problemIdentifiers count] > 0)
    {
        _problems = [TKOProblem problemsWithIdentifiers:problemIdentifiers];
    }
    
    return self;
}

- (id)propertyListRepresentation
{
    NSMutableDictionary *dict = [super propertyListRepresentation];
    
    NSAssert([dict isKindOfClass:[NSMutableDictionary class]], nil);
    
    if (self.directions) dict[TKODirectionsKey] = self.directions;
    
    
    return dict;
}

@end
