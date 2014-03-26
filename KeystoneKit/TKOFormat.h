//
//  TKOFormat.h
//  TKOKeystonePlistDemo
//
//  Created by Todd Olsen on 3/23/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKOBaseEntity.h"

@interface TKOFormat : TKOBaseEntity

@property (nonatomic,readonly) NSAttributedString * directions;
@property (nonatomic,readonly) NSUInteger duration;
@property (nonatomic,readonly) NSSet * problems;

+ (instancetype)formatForIdentifier:(NSString *)identifier;

@end
