//
//  TKOTemplateViewController.m
//  TKOKeystoneProblemEditorDemo
//
//  Created by Todd Olsen on 3/19/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOTemplateViewController.h"
#import "NSView+TKOKit.h"

#import "TKOTextView.h"
#import "TKOTextStorage.h"

#import "TKOTemplatePicker.h"
#import "TKOProblemTemplate.h"
#import "TKOProblemTemplateAuthority.h"

@interface TKOTemplateViewController () <TKOTemplatePickerDelegate>

@property (strong, nonatomic) TKOTemplatePicker * problemTemplatePicker;
@property (strong, nonatomic) TKOProblemTemplateAuthority * problemTemplateAuthority;

@property (strong, nonatomic) TKOSecondViewController * secondViewController;

@end

@implementation TKOTemplateViewController

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

- (void)textViewDidChangeSelection:(NSNotification *)notification
{
    NSInteger location = self.textView.selectedRange.location;
    if (location >= self.textView.textStorage.length || location == NSNotFound)
    {
        [self.problemTemplatePicker setSelectedItem:nil];
        
    } else {
        
        NSString * attributeName = [self.textView.textStorage attribute:TKOProblemTemplateName
                                                                atIndex:location
                                                         effectiveRange:NULL];
        
        [self.problemTemplatePicker setSelectedItem:[TKOProblemTemplateAuthority problemTemplateWithName:attributeName]];
    }
}

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

- (id)init
{
    self = [super init];
    if (!self)
        return nil;

    self.view = [NSView viewWithClass:[NSView class]];
    self.title = @"Template";
    
    _problemTemplateAuthority = [[TKOProblemTemplateAuthority alloc] init];
    _problemTemplatePicker = [[TKOTemplatePicker alloc] initWithTitle:nil];
    _problemTemplatePicker.dataSource = _problemTemplateAuthority;
    _problemTemplatePicker.delegate = self;
    
    _secondViewController = [[TKOSecondViewController alloc] init];
    NSView * answerView = _secondViewController.view;
    
    NSDictionary * views = NSDictionaryOfVariableBindings(_problemTemplatePicker, answerView);
    [self.view addSubview:_problemTemplatePicker];
    [self.view addSubview:answerView];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_problemTemplatePicker][answerView]"
                                             options:0
                                             metrics:nil
                                               views:views]
     ];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_problemTemplatePicker]|"
                                             options:0
                                             metrics:nil
                                               views:views]
     ];
    
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[answerView]|"
                                             options:0
                                             metrics:nil
                                               views:views]
     ];
    
    return self;
}

@end
