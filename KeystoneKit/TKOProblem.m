//
//  TKOProblem.m
//  TKOKeystonePlistDemo
//
//  Created by Todd Olsen on 3/23/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOProblem.h"
#import "TKOFormat.h"

static NSCache * problemsCache = nil;

@implementation TKOProblem

+ (void)initialize
{
    if (!problemsCache) problemsCache = [[NSCache alloc] init];
}

+ (NSSet *)problemsWithIdentifiers:(NSArray *)identifiers
{
    NSSet * problems;
    
    
    return problems;
}

- (id)initWithIdentifier:(NSString *)identifier
               timestamp:(NSDate *)timestamp
                    name:(NSString *)name
                    tags:(NSSet *)tags
          attributedText:(NSAttributedString *)attributedText
       answerDescription:(NSString *)answerDescription
    multipleChoiceAnswer:(NSUInteger)multipleChoiceAnswer
                  format:(TKOFormat *)format
{
    self = [super initWithIdentifier:identifier
                           timestamp:timestamp
                                name:name
                                tags:tags];
    if (!self) return nil;
    
    _attributedText       = [attributedText copy];
    _answerDescription    = [answerDescription copy];
    _multipleChoiceAnswer = multipleChoiceAnswer;
    _format               = format;
    
    return self;
}

# pragma mark - Property List Serialization

- (instancetype)initWithPropertyListRepresentation:(id)plist
{
    self = [super initWithPropertyListRepresentation:plist];

    id attributedText           = plist[TKOAttributedTextKey];
    id answerDescription        = plist[TKOAnswerDescriptionKey];
    id multipleChoiceAnswer     = plist[TKOMultipleChoiceAnswerKey];
    id formatIdentifier         = plist[TKOFormatIdentifierKey];
    
    _attributedText = [attributedText isKindOfClass:[NSAttributedString class]] ? attributedText : nil;
    _answerDescription = [answerDescription isKindOfClass:[NSString class]] ? answerDescription : nil;
    _multipleChoiceAnswer = multipleChoiceAnswer ? [multipleChoiceAnswer integerValue] : NSNotFound;
    _format = formatIdentifier && [formatIdentifier isKindOfClass:[NSString class]] ? [TKOFormat formatForIdentifier:formatIdentifier] : nil;
    
    return self;
}
                            
- (id)propertyListRepresentation
{
    NSMutableDictionary *dict = [super propertyListRepresentation];
    
    NSAssert([dict isKindOfClass:[NSMutableDictionary class]], nil);
    
    if (self.attributedText) dict[TKOAttributedTextKey] = self.attributedText;
    if (self.answerDescription) dict[TKOAnswerDescriptionKey] = self.answerDescription;
    if (self.multipleChoiceAnswer != NSNotFound) dict[TKOMultipleChoiceAnswerKey] = @(self.multipleChoiceAnswer);
    if (self.format.identifier) dict[TKOFormatIdentifierKey] = self.format.identifier;

    return dict;
}



@end
