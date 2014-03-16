//
//  TKOProblemTemplate.h
//  TKOProblemTemplateDemo
//
//  Created by Todd Olsen on 3/13/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKOProblemTemplate : NSObject

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSParagraphStyle * paragraphStyle;
@property (strong, nonatomic, readonly) NSDictionary * attributes;
@end
