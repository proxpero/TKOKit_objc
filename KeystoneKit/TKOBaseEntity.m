//
//  TKOBaseEntity.m
//  TKOKeystonePlistDemo
//
//  Created by Todd Olsen on 3/23/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOBaseEntity.h"
#import "TKOTag.h"

@implementation TKOBaseEntity

- (id)initWithIdentifier:(NSString *)identifier
               timestamp:(NSDate *)timestamp
                    name:(NSString *)name
                    tags:(NSSet *)tags
{
    self = [super init];
    if (!self) return nil;
    
    _identifier = identifier ? [identifier copy] : [[NSUUID UUID] UUIDString];
    _timestamp  = timestamp ? [timestamp copy] : [NSDate date];
    _name       = [name copy];
    _tags       = tags;
    
    return self;
}

# pragma mark - Property List Serialization

+ (instancetype)problemWithPropertyListRepresentation:(id)plist
{
    Class class = plist[TKOClassKey];
    return [[class alloc] initWithPropertyListRepresentation:plist];
}

- (instancetype)initWithPropertyListRepresentation:(id)plist
{
    id identifier       = plist[TKOIdentifierKey];
    id timestamp        = plist[TKOTimestampKey];
    id name             = plist[TKONameKey];
    id tagIdentifiers   = plist[TKOTagsKey];
    
    NSSet * tags;
    if (tagIdentifiers && [tagIdentifiers isKindOfClass:[NSArray class]] && [tagIdentifiers count] > 0)
        tags = [TKOTag tagsWithIdentifiers:tagIdentifiers];
    
    return [self initWithIdentifier:identifier
                          timestamp:timestamp
                               name:name
                               tags:tags];
}

- (id)propertyListRepresentation
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSAssert(self.identifier, nil);
    NSAssert(self.timestamp, nil);
    
    dict[TKOClassKey]               = NSStringFromClass([self class]);
    dict[TKOIdentifierKey]          = self.identifier;
    dict[TKOTimestampKey]           = self.timestamp;
    if (self.name) dict[TKONameKey] = self.name;
    
    NSArray * tagIdentifiers = [TKOTag identifiersForTags:self.tags];
    if (tagIdentifiers && [tagIdentifiers count] > 0)
        dict[TKOTagsKey] = tagIdentifiers;
    
    return dict;
}

@end