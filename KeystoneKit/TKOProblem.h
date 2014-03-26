//
//  TKOProblem.h
//  TKOKeystonePlistDemo
//
//  Created by Todd Olsen on 3/23/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKOBaseEntity.h"
#import "TKOFormat.h"

@interface TKOProblem : TKOBaseEntity

@property (nonatomic,readonly) NSAttributedString * attributedText;
@property (nonatomic,readonly) NSString * answerDescription;
@property (nonatomic,readonly) NSUInteger multipleChoiceAnswer;
@property (nonatomic,readonly) TKOFormat * format;

+ (NSSet *)problemsWithIdentifiers:(NSArray *)identifiers;

- (instancetype)initWithIdentifier:(NSString *)identifier
                         timestamp:(NSDate *)timestamp
                              name:(NSString *)name
                              tags:(NSSet *)tags
                    attributedText:(NSAttributedString *)attributedText
                 answerDescription:(NSString *)answerDescription
              multipleChoiceAnswer:(NSUInteger)multipleChoiceAnswer
                            format:(TKOFormat *)format;



@end
