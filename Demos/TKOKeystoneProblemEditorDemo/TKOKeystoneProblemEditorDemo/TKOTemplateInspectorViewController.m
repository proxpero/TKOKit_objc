//
//  TKOTemplateInspectorViewController.m
//  TKOKeystoneProblemEditorDemo
//
//  Created by Todd Olsen on 3/19/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOTemplateInspectorViewController.h"
#import "NSView+TKOKit.h"

#import "TKOTemplatePicker.h"
#import "TKOProblemTemplate.h"
#import "TKOMultipleChoiceAnswerView.h"
#import "TKODifficultyInspectorViewController.h"
#import "TKOTagsInspectorViewController.h"

#import "TKOTextView.h"
#import "TKOTextStorage.h"

@interface TKOTemplateInspectorViewController () <TKOTemplatePickerDelegate, TKOMultipleChoiceAnswerDataSource>
@property (nonatomic) IBOutlet NSScrollView *inspectorScrollView;
@property (nonatomic) IBOutlet NSStackView *inspectorStackView;

@property (nonatomic) TKOMultipleChoiceAnswerView * answerInspector;
@property (nonatomic) TKODifficultyInspectorViewController * difficultyInspector;
@property (nonatomic) TKOTagsInspectorViewController * tagsInspector;
@property (nonatomic) TKOTemplatePicker * templatePicker;

@end

@implementation TKOTemplateInspectorViewController
{
    NSArray * _multipleChoiceTitles;
}

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

- (void)setTextView:(TKOTextView *)textView
{
    if (_textView == textView)
        return;
    
    NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];

    if ([self respondsToSelector:@selector(textViewDidChangeSelection:)])
        [defaultCenter removeObserver:self
                                 name:NSTextViewDidChangeSelectionNotification
                               object:_textView];

    if ([self respondsToSelector:@selector(textStorageDidProcessEditing:)])
        [defaultCenter removeObserver:self
                                 name:NSTextStorageDidProcessEditingNotification
                               object:_textView.textStorage];

    _textView = textView;

    if ([self respondsToSelector:@selector(textViewDidChangeSelection:)])
        [defaultCenter addObserver:self
                          selector:@selector(textViewDidChangeSelection:)
                              name:NSTextViewDidChangeSelectionNotification
                            object:_textView];

    if ([self respondsToSelector:@selector(textStorageDidProcessEditing:)])
        [defaultCenter addObserver:self
                          selector:@selector(textStorageDidProcessEditing:)
                              name:NSTextStorageDidProcessEditingNotification
                            object:_textView.textStorage];
}

- (id)init
{
    self = [super initWithNibName:@"TKOTemplateInspectorViewController"
                           bundle:nil];
    if (!self)
        return nil;

    _multipleChoiceTitles = @[ @"A", @"B", @"C", @"D", @"E" ];
    self.title = @"Template";
    
    _templatePicker = [NSView viewWithClass:[TKOTemplatePicker class]];
    _templatePicker.delegate = self;
    
    _answerInspector = [[TKOMultipleChoiceAnswerView alloc] init];
    _answerInspector.dataSource = self;
    
    _difficultyInspector = [[TKODifficultyInspectorViewController alloc] init];
    
    _tagsInspector = [[TKOTagsInspectorViewController alloc] init];
    
    return self;
}

- (void)awakeFromNib
{
    [self.inspectorStackView addView:self.templatePicker
                           inGravity:NSStackViewGravityTop];
    
    [self.inspectorStackView addView:[NSView separator]
                           inGravity:NSStackViewGravityTop];
    
    [self.inspectorStackView addView:self.answerInspector
                           inGravity:NSStackViewGravityTop];
    
    [self.inspectorStackView addView:[NSView separator]
                           inGravity:NSStackViewGravityTop];
    
    NSView * di = self.difficultyInspector.view;
    
    [self.inspectorStackView addView:self.difficultyInspector.view
                           inGravity:NSStackViewGravityTop];
    
    [self.inspectorStackView addView:[NSView separator]
                           inGravity:NSStackViewGravityTop];
    
    [self.inspectorStackView addView:self.tagsInspector.view
                           inGravity:NSStackViewGravityTop];
    
    [self.inspectorStackView addView:[NSView separator]
                           inGravity:NSStackViewGravityTop];
    
    [self.inspectorScrollView setDocumentView:self.inspectorStackView];
}

# pragma mark - TKOMultipleChoiceAnswerView

- (NSUInteger)multipleChoiceViewNumberOfChoices:(TKOMultipleChoiceAnswerView *)multipleChoiceView
{
    return _multipleChoiceTitles.count;
}

- (NSString *)multipleChoiceView:(TKOMultipleChoiceAnswerView *)multipleChoiceView
                    titleAtIndex:(NSUInteger)index
{
    return _multipleChoiceTitles[index];
}

@end
