//
//  TKOProblemTemplateAuthority.h
//  TKOProblemTemplateClassDemo
//
//  Created by Todd Olsen on 3/13/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKOTemplatePicker.h"

@class TKOProblemTemplate;

@interface TKOProblemTemplateAuthority : NSObject <TKOTemplatePickerDataSource>

+ (TKOProblemTemplate *)problemTemplateWithName:(NSString *)name;

@end

extern NSString * TKOProblemTemplateName;
extern NSString * TKOProblemTemplateAttributes;