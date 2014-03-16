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
       
        NSMutableArray * templates = [NSMutableArray new];
        TKOProblemTemplate * template;
        
        template = [[TKOProblemTemplate alloc] init];
        template.name = @"Template 1";
        template.paragraphStyle = [[NSParagraphStyle alloc] init];
        [templates addObject:template];
        
        NSMutableParagraphStyle * style2 = [[[NSParagraphStyle alloc] init] mutableCopy];
        [style2 setHeadIndent:30.0];
        
        template = [[TKOProblemTemplate alloc] init];
        template.name = @"Template 2";
        template.paragraphStyle = style2;
        [templates addObject:template];
        
        _templates = templates;
    });
}

+ (TKOProblemTemplate *)templateWithName:(NSString *)name
{
    for (TKOProblemTemplate * item in _templates)
        if ([item.name isEqualToString:name])
            return item;
    return nil;
}

- (NSUInteger)templatePickerNumberOfItems:(TKOTemplatePicker *)templatePicker
{
    return _templates.count;
}

- (id)templatePicker:(TKOTemplatePicker *)templatePicker
         itemAtIndex:(NSUInteger)index
{
    return (TKOProblemTemplate *)_templates[index];
}

- (NSString *)templatePicker:(TKOTemplatePicker *)templatePicker
                titleForItem:(id)item
{
    return ((TKOProblemTemplate *)item).name;
}


@end
