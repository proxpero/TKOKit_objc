//
//  TKOAlignmentInspectorViewController.m
//  TKOAlignmentInspectorViewDemo
//
//  Created by Todd Olsen on 2/11/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOAlignmentInspectorViewController.h"
#import "TKOTextSystem.h"

@interface TKOAlignmentInspectorViewController ()

@property (nonatomic) NSTextAlignment alignment;
@property (nonatomic) CGFloat headIndent;
@property (nonatomic) CGFloat firstLineHeadIndent;

@property (weak) IBOutlet NSSegmentedControl *alignmentControl;
@property (weak) IBOutlet NSSegmentedControl *indentationControl;
@property (weak) IBOutlet NSSegmentedControl *positioningControl;

- (IBAction)modifyAlignmentAction:(id)sender;
- (IBAction)modifyIndentationAction:(id)sender;
- (IBAction)modifyPositioningAction:(id)sender;

@end

@implementation TKOAlignmentInspectorViewController

- (id)init
{
    self = [super initWithNibName:@"TKOAlignmentInspectorViewController"
                           bundle:nil];
    if (!self)
        return nil;
    
    return self;
}

- (id)initWithTextView:(TKOTextView *)textView
{
    self = [self init];
    
    [self setTextView:textView];
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setTextView:(TKOTextView *)textView
{
    if (_textView == textView)
        return;
    
    NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self
                             name:NSTextViewDidChangeSelectionNotification
                           object:_textView];
    
    _textView = textView;
    
    [defaultCenter addObserver:self
                      selector:@selector(textViewDidChangeAlignment:)
                          name:NSTextViewDidChangeSelectionNotification
                        object:_textView];
}

- (void)textViewDidChangeAlignment:(NSNotification *)notification
{
    [self setTextView:[notification object]];
    
    // Alignment
    
    NSTextAlignment alignment = 0;
    CGFloat headIndent, firstLineHeadIndent;
    
    NSArray * ranges = [self.textView selectedRanges];
    for (NSValue * range in ranges) {
        NSInteger location = [range rangeValue].location;
        
        if (location != NSNotFound && location < self.textView.textStorage.length) {
            NSParagraphStyle * paragraphStyle = [self.textView.textStorage attribute:NSParagraphStyleAttributeName
                                                                             atIndex:location
                                                                      effectiveRange:NULL];
            alignment           = [paragraphStyle alignment];
            headIndent          = [paragraphStyle headIndent];
            firstLineHeadIndent = [paragraphStyle firstLineHeadIndent];
        }
    }
    [self setAlignment:alignment];
    [self setHeadIndent:headIndent];
    [self setFirstLineHeadIndent:firstLineHeadIndent];
}

- (void)validateIndentationControl
{
    [self.indentationControl setEnabled:(_headIndent > 0 && _firstLineHeadIndent > 0)
                             forSegment:0];
}

- (void)setAlignment:(NSTextAlignment)alignment
{
    _alignment = alignment;
    [self.alignmentControl selectSegmentWithTag:_alignment];
}

- (void)setHeadIndent:(CGFloat)headIndent
{
    _headIndent = headIndent;
    [self validateIndentationControl];
}

- (void)setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent
{
    _firstLineHeadIndent = firstLineHeadIndent;
    [self validateIndentationControl];
}

- (IBAction)modifyAlignmentAction:(id)sender
{
    NSTextAlignment alignment = [self.alignmentControl.cell tagForSegment:self.alignmentControl.selectedSegment];
    [self setAlignment:alignment];
    
    NSArray * ranges = self.textView.selectedRanges;
    for (NSValue * value in ranges) {
        NSRange range = [value rangeValue];
        NSRange paragraphRange = [self.textView.textStorage.string paragraphRangeForRange:range];
        if (range.location < self.textView.string.length) {
            
            NSMutableParagraphStyle * paragraphStyle = [[self.textView.textStorage attribute:NSParagraphStyleAttributeName
                                                                                    atIndex:range.location
                                                                             effectiveRange:NULL] mutableCopy];
            [paragraphStyle setAlignment:alignment];
            [self.textView.textStorage addAttribute:NSParagraphStyleAttributeName
                                              value:paragraphStyle
                                              range:paragraphRange];
        }
    }
}

- (IBAction)modifyIndentationAction:(id)sender
{
    if ([sender selectedSegment] == 0) {    // decrease indentation
        
        NSArray * ranges = self.textView.selectedRanges;
        for (NSValue * value in ranges) {
            NSRange range = [value rangeValue];
            NSRange paragraphRange = [self.textView.textStorage.string paragraphRangeForRange:range];
            if (range.location < self.textView.string.length) {
                
                NSMutableParagraphStyle * paragraphStyle = [[self.textView.textStorage attribute:NSParagraphStyleAttributeName
                                                                                         atIndex:range.location
                                                                                  effectiveRange:NULL] mutableCopy];
                CGFloat space = 3.0 * 10.0;
                
                CGFloat headIndent = (paragraphStyle.headIndent - space);
                if (headIndent < 0)
                    headIndent = 0;
                [paragraphStyle setHeadIndent:headIndent];
                
                CGFloat firstLine = (paragraphStyle.firstLineHeadIndent - space);
                if (firstLine < 0)
                    firstLine = 0;
                [paragraphStyle setFirstLineHeadIndent:firstLine];
                
                [self setHeadIndent:headIndent];
                [self setFirstLineHeadIndent:firstLine];
                
                [self.textView.textStorage addAttribute:NSParagraphStyleAttributeName
                                                  value:paragraphStyle
                                                  range:paragraphRange];
            }
        }
        
    } else {                                // increase indentation
        
        NSArray * ranges = self.textView.selectedRanges;
        for (NSValue * value in ranges) {
            NSRange range = [value rangeValue];
            NSRange paragraphRange = [self.textView.textStorage.string paragraphRangeForRange:range];
            if (range.location < self.textView.string.length) {
                
                NSMutableParagraphStyle * paragraphStyle = [[self.textView.textStorage attribute:NSParagraphStyleAttributeName
                                                                                         atIndex:range.location
                                                                                  effectiveRange:NULL] mutableCopy];
                CGFloat space = 3.0 * 10.0;
                
                CGFloat headIndent  = paragraphStyle.headIndent + space;
                CGFloat firstLine   = paragraphStyle.firstLineHeadIndent + space;
                
                [paragraphStyle setHeadIndent:headIndent];
                [paragraphStyle setFirstLineHeadIndent:firstLine];
                
                [self setHeadIndent:headIndent];
                [self setFirstLineHeadIndent:firstLine];

                [self.textView.textStorage addAttribute:NSParagraphStyleAttributeName
                                                  value:paragraphStyle
                                                  range:paragraphRange];
            }
        }
        
    }
}

- (IBAction)modifyPositioningAction:(id)sender { }

@end
