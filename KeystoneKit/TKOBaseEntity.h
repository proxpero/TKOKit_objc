//
//  TKOBaseEntity.h
//  TKOKeystonePlistDemo
//
//  Created by Todd Olsen on 3/23/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKOBaseEntity : NSObject

@property (nonatomic,readonly) NSString * identifier;
@property (nonatomic,readonly) NSDate * timestamp;
@property (nonatomic,readonly) NSString * name;
@property (nonatomic,readonly) NSSet * tags;

- (instancetype)initWithIdentifier:(NSString *)identifier
                         timestamp:(NSDate *)timestamp
                              name:(NSString *)name
                              tags:(NSSet *)tags;
- (instancetype)initWithPropertyListRepresentation:(id)plist;

# pragma mark - Property List Serialization
+ (instancetype)problemWithPropertyListRepresentation:(id)plist;
- (id)propertyListRepresentation;

@end

# pragma mark - Base Entity Keys
NSString * const TKOIdentifierKey;
NSString * const TKOTimestampKey;
NSString * const TKONameKey;
NSString * const TKOTagsKey;
NSString * const TKOClassKey;

# pragma mark - Problem Keys
NSString * const TKOAttributedTextKey;
NSString * const TKOAnswerDescriptionKey;
NSString * const TKOMultipleChoiceAnswerKey;
NSString * const TKOFormatIdentifierKey;

#pragma mark - Format Keys
NSString * const TKODirectionsKey;
NSString * const TKODurationKey;
NSString * const TKOProblemsKey;

