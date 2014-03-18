//
//  TKOProblemTemplate.h
//  TKOProblemTemplateDemo
//
//  Created by Todd Olsen on 3/13/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKOTemplatePicker.h"

@interface TKOProblemTemplate : NSObject 

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSDictionary * attributes;
@property (strong, nonatomic, readonly) NSTextList * choicesList;

- (id)initWithName:(NSString *)name
        attributes:(NSDictionary *)attributes;

@end
