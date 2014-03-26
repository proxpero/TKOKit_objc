//
//  TKOTag.h
//  TKOKeystonePlistDemo
//
//  Created by Todd Olsen on 3/23/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOBaseEntity.h"

@interface TKOTag : TKOBaseEntity


+ (NSSet *)tagsWithIdentifiers:(NSArray *)identifiers;
+ (NSArray *)identifiersForTags:(NSSet *)tags;

@end
