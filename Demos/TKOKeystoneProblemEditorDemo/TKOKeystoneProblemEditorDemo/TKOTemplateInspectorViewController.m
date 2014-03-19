//
//  TKOTemplateInspectorViewController.m
//  TKOKeystoneProblemEditorDemo
//
//  Created by Todd Olsen on 3/19/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOTemplateInspectorViewController.h"
#import "TKOTemplatePicker.h"
#import "TKOProblemTemplate.h"
#import "TKOProblemTemplateAuthority.h"

#import "TKOTextView.h"
#import "TKOTextStorage.h"

@interface TKOTemplateInspectorViewController () <TKOTemplatePickerDelegate>

@property (strong) IBOutlet TKOTemplatePicker *templatePicker;


@end

@implementation TKOTemplateInspectorViewController

# pragma mark - Text View Notifications

- (void)textViewDidChangeSelection:(NSNotification *)notification
{
    TKOTextView * textView = [notification object];
    
    NSInteger location = textView.selectedRange.location;
    if (location >= textView.textStorage.length || location == NSNotFound)
    {
        [self.templatePicker setSelectedItem:nil];
        
    } else {
        
        NSString * attributeName = [textView.textStorage attribute:TKOProblemTemplateName
                                                                atIndex:location
                                                         effectiveRange:NULL];
        
        [self.templatePicker setSelectedItem:[TKOProblemTemplateAuthority problemTemplateWithName:attributeName]];
    }
}

# pragma mark - Text Storage Notifications

- (void)textStorageWillProcessEditing:(NSNotification *)notification
{
    NSInteger location = self.textView.selectedRange.location;
    if (location >= self.textView.textStorage.length || location == NSNotFound)
        return;
    
    TKOTextStorage * textStorage = [notification object];
    
    [self.textView.string enumerateSubstringsInRange:NSMakeRange(0, self.textView.string.length)
                                             options:NSStringEnumerationByParagraphs
                                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                              
                                              NSString * name = [textStorage attribute:TKOProblemTemplateName
                                                                               atIndex:substringRange.location
                                                                        effectiveRange:NULL];
                                              TKOProblemTemplate * template = [TKOProblemTemplateAuthority problemTemplateWithName:name];
                                              
                                              NSTextList * textList = template.choicesList;
                                              
                                              if (textList)
                                              {
                                                  NSParagraphStyle * paragraphStyle = [textStorage attribute:NSParagraphStyleAttributeName
                                                                                                     atIndex:substringRange.location
                                                                                              effectiveRange:NULL];
                                                  NSArray * lists = [paragraphStyle textLists];
                                                  
                                                  NSTextList * newTextList = lists[0];
                                                  
                                                  if ((newTextList != textList) || lists.count > 1)
                                                  {
                                                      NSMutableParagraphStyle * mps = [paragraphStyle mutableCopy];
                                                      [mps setTextLists:@[ textList ]];
                                                  }
                                                  
                                                  NSString * marker = [textList markerForItemNumber:[textStorage itemNumberInTextList:textList
                                                                                                                              atIndex:substringRange.location]];
                                                  if (marker)
                                                  {
                                                      if (![substring hasPrefix:marker])
                                                      {
                                                          NSAttributedString * attributedMarker = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\t",marker]
                                                                                                                                  attributes:[textStorage attributesAtIndex:substringRange.location
                                                                                                                                                             effectiveRange:NULL]];
                                                          [textStorage insertAttributedString:attributedMarker
                                                                                      atIndex:substringRange.location];
                                                      }
                                                  }
                                              }
                                          }];
}

# pragma mark - Template Picker Delegate

- (void)templatePickerDidChangeSelection:(NSNotification *)notification
{
    TKOTemplatePicker * picker = [notification object];
    
    NSInteger location = self.textView.selectedRange.location;
    if (location >= self.textView.textStorage.length || location == NSNotFound)
        return;
    
    TKOProblemTemplate * problemTemplate = picker.selectedItem;
    
    NSRange range = self.textView.rangeForUserParagraphAttributeChange;
    [self.textView.textStorage addAttributes:problemTemplate.attributes
                                       range:range];
}

- (id)init
{
    self = [super initWithNibName:@"TKOTemplateInspectorViewController"
                           bundle:nil];
    if (!self)
        return nil;
    
    self.title = @"Template";
    
    
    return self;
}



@end