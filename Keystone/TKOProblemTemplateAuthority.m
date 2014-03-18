//
//  TKOProblemTemplateAuthority.m
//  TKOProblemTemplateClassDemo
//
//  Created by Todd Olsen on 3/13/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOProblemTemplateAuthority.h"
#import "TKOProblemTemplate.h"

static NSArray * _templates = nil;

@implementation TKOProblemTemplateAuthority

+ (void)initialize
{
    static dispatch_once_t oneAuthority;
    
    dispatch_once(&oneAuthority, ^{
        
        NSMutableParagraphStyle * mpStyle;
        
        mpStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        mpStyle.paragraphSpacing = 12.0;

        TKOProblemTemplate * question = [[TKOProblemTemplate alloc] initWithName:@"Question"
                                                                      attributes:@{NSParagraphStyleAttributeName: mpStyle}];
        mpStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];

        [mpStyle addTabStop:[[NSTextTab alloc] initWithType:NSLeftTabStopType location:20.0]];
        [mpStyle setHeadIndent:20.0];
        mpStyle.paragraphSpacing = 6.0;
        
        NSTextList * choicesList;
        choicesList = [[NSTextList alloc] initWithMarkerFormat:@"({upper-alpha})"
                                                       options:0];
        [choicesList setStartingItemNumber:1];
        [mpStyle setTextLists:@[choicesList]];
        
        TKOProblemTemplate * choices  = [[TKOProblemTemplate alloc] initWithName:@"Choices"
                                                                      attributes:@{NSParagraphStyleAttributeName: mpStyle}];
        _templates = @[ question, choices ];
    });
}

+ (TKOProblemTemplate *)problemTemplateWithName:(NSString *)name
{
    if (!name)
        return nil;
    
    for (TKOProblemTemplate * template in _templates)
        if ([template.name isEqualToString:name])
            return template;
    
    return nil;
}

#pragma mark - TKOTemplatePicker Data Source

- (NSUInteger)templatePickerNumberOfItems:(TKOTemplatePicker *)templatePicker
{
    return _templates.count;
}

- (id)templatePicker:(TKOTemplatePicker *)templatePicker
         itemAtIndex:(NSUInteger)index
{
    return _templates[index];
}

- (NSString *)templatePicker:(TKOTemplatePicker *)templatePicker
                titleForItem:(id)item
{
    return [(TKOProblemTemplate *)item name];
}

@end

NSString * TKOProblemTemplateName = @"TKOProblemTemplateName";
NSString * TKOProblemTemplateAttributes = @"TKOProblemTemplateAttributes";
