//
//  TKODocument.m
//  TKOProblemTemplateClassDemo
//
//  Created by Todd Olsen on 3/5/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKODocument.h"
#import "NSView+TKOKit.h"
#import "TKOTextSystem.h"
#import "NSScrollView+TKOKit.h"

#import "TKOTemplatePicker.h"
#import "TKOProblemTemplate.h"
#import "TKOProblemTemplateAuthority.h"

#import "TKOAlignmentInspectorViewController.h"
#import "TKOFontInspectorViewController.h"

@interface TKODocument () <NSTextViewDelegate, NSTextStorageDelegate, TKOTemplatePickerDelegate>

@property (strong, nonatomic) TKOTextView * textView;
@property (strong, nonatomic) TKOTextStorage * textStorage;
@property (weak) IBOutlet NSScrollView *textScrollView;

@property (weak) IBOutlet NSStackView *stackView;

@property (strong, nonatomic) TKOTemplatePicker * picker;
@property (strong, nonatomic) TKOProblemTemplateAuthority * templateAuthority;

@end

@implementation TKODocument

- (void)textStorageWillProcessEditing:(NSNotification *)notification
{
    NSInteger location = self.textView.selectedRange.location;
    if (location >= self.textView.textStorage.length || location == NSNotFound)
        return;
    
    TKOTextStorage * ts = [notification object];
    
    [self.textView.string enumerateSubstringsInRange:NSMakeRange(0, self.textView.string.length)
                                             options:NSStringEnumerationByParagraphs
                                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                              
                                              NSString * name = [self.textStorage attribute:TKOProblemTemplateName
                                                                                    atIndex:substringRange.location
                                                                             effectiveRange:NULL];
                                              TKOProblemTemplate * template = [TKOProblemTemplateAuthority problemTemplateWithName:name];
                                              
                                              NSTextList * textList = template.choicesList;
                                              
                                              if (textList)
                                              {
                                                  NSParagraphStyle * paragraphStyle = [self.textStorage attribute:NSParagraphStyleAttributeName
                                                                                                          atIndex:substringRange.location
                                                                                                   effectiveRange:NULL];
                                                  NSTextList * newTextList = [paragraphStyle textLists][0];
                                                  
                                                  if (newTextList != textList)
                                                  {
                                                      NSMutableParagraphStyle * mps = [paragraphStyle mutableCopy];
                                                      [mps setTextLists:@[ textList ]];
                                                  }
                                                  
                                                  NSString * marker = [textList markerForItemNumber:[ts itemNumberInTextList:textList
                                                                                                                     atIndex:substringRange.location]];
                                                  if (marker)
                                                  {
                                                      if (![substring hasPrefix:marker])
                                                      {
                                                          NSAttributedString * attributedMarker = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\t",marker]
                                                                                                                                  attributes:[self.textStorage attributesAtIndex:substringRange.location
                                                                                                                                                                  effectiveRange:NULL]];
                                                          [ts insertAttributedString:attributedMarker
                                                                             atIndex:substringRange.location];
                                                      }
                                                  }
                                              }
                                          }];
}

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
        [self.picker setSelectedItem:nil];
        
    } else {
        
        NSString * attributeName = [self.textView.textStorage attribute:TKOProblemTemplateName
                                                                atIndex:location
                                                         effectiveRange:NULL];
        
        [self.picker setSelectedItem:[TKOProblemTemplateAuthority problemTemplateWithName:attributeName]];
    }
}

- (void)setupTextSystem
{
    NSLayoutManager * layoutManager = [[NSLayoutManager alloc] init];
    [self.textStorage addLayoutManager:layoutManager];
    
    TKOTextContainer * textContainer = [[TKOTextContainer alloc] init];
    [layoutManager addTextContainer:textContainer];
    self.textView = [[TKOTextView alloc] initWithFrame:NSZeroRect
                                         textContainer:textContainer];
    self.textView.delegate = self;
    self.textStorage.delegate = self;
    [self.textView setTextContainerInset:NSMakeSize(20, 20)];
    [self.textScrollView setDocumentView:self.textView];
}

- (id)init
{
    self = [super init];
    if (self) {
        _textStorage = [[TKOTextStorage alloc] init];
        _templateAuthority = [[TKOProblemTemplateAuthority alloc] init];
    }
    return self;
}

- (NSString *)windowNibName
{
    return @"TKODocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    
    self.picker = [[TKOTemplatePicker alloc] initWithTitle:@"Template"];
    [self.stackView addView:self.picker
                  inGravity:NSStackViewGravityTop];
    [self.stackView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[picker]|"
                                             options:0
                                             metrics:nil
                                               views:@{@"picker": self.picker}]
     ];
    
    [self.picker setDelegate:self];
    [self.picker setDataSource:self.templateAuthority];
    [self setupTextSystem];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName
                 error:(NSError **)outError
{
    NSAttributedString * string = [self.textStorage attributedSubstringFromRange:NSMakeRange(0, self.textStorage.length)];
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:string];
    return data;
}

- (BOOL)readFromData:(NSData *)data
              ofType:(NSString *)typeName
               error:(NSError **)outError
{
    NSAttributedString * string = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (string) {
        [self.textStorage setAttributedString:string];
        return YES;
    }
    return NO;
}


@end
