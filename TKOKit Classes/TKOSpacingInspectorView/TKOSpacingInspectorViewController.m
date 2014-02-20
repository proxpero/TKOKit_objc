//
//  TKOSpacingInspectorViewController.m
//  TKOSpacingInspectorDemo
//
//  Created by Todd Olsen on 2/13/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOSpacingInspectorViewController.h"
#import "TKOTextSystem.h"

typedef enum {
    TKOLineSpacingModeLines,
    TKOLineSpacingModeAtLeast,
    TKOLineSpacingModeExactly,
    TKOLineSpacingModeBetween,
} TKOLineSpacingMode;

@interface TKOSpacingInspectorViewController ()

@property (nonatomic) TKOLineSpacingMode lineSpacingMode;
@property (nonatomic) CGFloat lineSpacing;
@property (nonatomic) CGFloat lineHeightMultiple;
@property (nonatomic) CGFloat maximumLineHeight;
@property (nonatomic) CGFloat minimumLineHeight;
@property (nonatomic) CGFloat paragraphSpacingBefore;
@property (nonatomic) CGFloat paragraphSpacingAfter;

@property (weak) IBOutlet NSTextField *lineSpacingTextField;
@property (weak) IBOutlet NSTextField *beforeParagraphTextField;
@property (weak) IBOutlet NSTextField *afterParagraphTextField;

@property (weak) IBOutlet NSStepper *lineSpacingStepper;
@property (weak) IBOutlet NSStepper *beforeParagraphStepper;
@property (weak) IBOutlet NSStepper *afterParagraphStepper;

- (IBAction)changeLineSpacingModeAction:(id)sender;

- (IBAction)modifyLineSpacingAction:(id)sender;
- (IBAction)modifyParagraphSpacingBeforeAction:(id)sender;
- (IBAction)modifyParagraphSpacingAfterAction:(id)sender;

@end

NSString * title = @"Spacing";
NSString * nibName = @"TKOSpacingInspectorViewController";
NSString * viewID = @"TKOSpacingContentViewIdentifier";

@implementation TKOSpacingInspectorViewController

- (void)textViewDidChangeSpacing:(NSNotification *)notification
{
    [self setTextView:[notification object]];
    
    CGFloat lineSpacing             = 0.0;
    CGFloat lineHeightMultiple      = 0.0;
    CGFloat maximumLineHeight       = 0.0;
    CGFloat minimumLineHeight       = 0.0;
    CGFloat paragraphSpacingBefore  = 0.0;
    CGFloat paragraphSpacingAfter   = 0.0;
    
    NSArray * ranges = [self.textView selectedRanges];
    for (NSValue * range in ranges) {
        NSInteger location = [range rangeValue].location;
        
        if (location != NSNotFound && location < self.textView.textStorage.length) {
            NSParagraphStyle * paragraphStyle = [self.textView.textStorage attribute:NSParagraphStyleAttributeName
                                                                             atIndex:location
                                                                      effectiveRange:NULL];
            
            lineSpacing             = [paragraphStyle lineSpacing];
            lineHeightMultiple      = [paragraphStyle lineHeightMultiple];
            if (lineHeightMultiple == 0.0)
                lineHeightMultiple = 1.0;
            
            maximumLineHeight       = [paragraphStyle maximumLineHeight];
            minimumLineHeight       = [paragraphStyle minimumLineHeight];
            
            paragraphSpacingBefore  = [paragraphStyle paragraphSpacingBefore];
            paragraphSpacingAfter   = [paragraphStyle paragraphSpacing];
        }
    }
    
    [self setLineSpacing:lineSpacing];
    [self.lineSpacingStepper setFloatValue:lineSpacing];
    [self setLineHeightMultiple:lineHeightMultiple];
    [self setMaximumLineHeight:maximumLineHeight];
    [self setMinimumLineHeight:minimumLineHeight];
    [self setParagraphSpacingBefore:paragraphSpacingBefore];
    [self setParagraphSpacingAfter:paragraphSpacingAfter];
}

# pragma mark - Line Spacing Mode

- (IBAction)changeLineSpacingModeAction:(id)sender
{
    [self setLineSpacingMode:(TKOLineSpacingMode)[sender selectedTag]];
}

- (void)setLineSpacingMode:(TKOLineSpacingMode)lineSpacingMode
{
    _lineSpacingMode = lineSpacingMode;
    switch (_lineSpacingMode) {
        case TKOLineSpacingModeLines:
            [self.lineSpacingStepper setIncrement:0.5];
            break;
        case TKOLineSpacingModeAtLeast:
        case TKOLineSpacingModeExactly:
        case TKOLineSpacingModeBetween:
        default:
            [self.lineSpacingStepper setIncrement:1.0];
            break;
    }
    [self setLineSpacingStringValue];
}

- (void)setLineSpacingStringValue
{
    CGFloat lineSpacingValue = 0.0;
    NSString * formatString = @"%g pt";
    
    switch (self.lineSpacingMode) {
        case TKOLineSpacingModeLines:
            lineSpacingValue = _lineHeightMultiple;
            formatString = @"%g";
            break;
        case TKOLineSpacingModeBetween:
            lineSpacingValue = _lineSpacing;
            break;
        case TKOLineSpacingModeExactly:
            lineSpacingValue = _minimumLineHeight;
            break;
        case TKOLineSpacingModeAtLeast:
            lineSpacingValue = _minimumLineHeight;
            break;
        default:
            break;
    }
    
    self.lineSpacingTextField.stringValue = [NSString stringWithFormat:formatString, lineSpacingValue];
}

# pragma mark - Line Spacing

- (void)setLineHeightMultiple:(CGFloat)lineHeightMultiple
{
    _lineHeightMultiple = lineHeightMultiple;
    [self.lineSpacingStepper setFloatValue:_lineHeightMultiple];
    [self setLineSpacingStringValue];
}

- (void)setLineSpacing:(CGFloat)lineSpacing
{
    _lineSpacing = lineSpacing;
    [self.lineSpacingStepper setFloatValue:_lineSpacing];
    [self setLineSpacingStringValue];
}

- (void)setMaximumLineHeight:(CGFloat)maximumLineHeight
{
    _maximumLineHeight = maximumLineHeight;
    [self setLineSpacingStringValue];
}

- (void)setMinimumLineHeight:(CGFloat)minimumLineHeight
{
    _minimumLineHeight = minimumLineHeight;
    [self.lineSpacingStepper setFloatValue:_minimumLineHeight];
    [self setLineSpacingStringValue];
}

- (IBAction)modifyLineSpacingAction:(id)sender
{
    CGFloat lineSpacing = [sender floatValue];
    
    switch (self.lineSpacingMode) {
        case TKOLineSpacingModeLines:
            self.lineHeightMultiple = lineSpacing;
            break;
        case TKOLineSpacingModeAtLeast:
            self.minimumLineHeight = lineSpacing;
            break;
        case TKOLineSpacingModeExactly:
            self.minimumLineHeight = lineSpacing;
            self.maximumLineHeight = lineSpacing;
            break;
        case TKOLineSpacingModeBetween:
            self.lineSpacing = lineSpacing;
        default:
            return;
            break;
    }

    NSArray * ranges = self.textView.selectedRanges;
    for (NSValue * value in ranges)
    {
        NSRange range = [value rangeValue];
        NSRange paragraphRange = [self.textView.textStorage.string paragraphRangeForRange:range];
        if (range.location < self.textView.string.length)
        {
            NSMutableParagraphStyle * paragraphStyle = [[self.textView.textStorage attribute:NSParagraphStyleAttributeName
                                                                                     atIndex:range.location
                                                                              effectiveRange:NULL] mutableCopy];

            switch (self.lineSpacingMode) {
                case TKOLineSpacingModeLines:
                    [paragraphStyle setLineHeightMultiple:self.lineHeightMultiple];
                    break;
                case TKOLineSpacingModeAtLeast:
                    [paragraphStyle setMinimumLineHeight:self.minimumLineHeight];
                    break;
                case TKOLineSpacingModeExactly:
                    [paragraphStyle setMinimumLineHeight:self.minimumLineHeight];
                    [paragraphStyle setMaximumLineHeight:self.maximumLineHeight];
                    break;
                case TKOLineSpacingModeBetween:
                    [paragraphStyle setLineSpacing:self.lineSpacing];
                    break;
                default:
                    break;
            }
            
            
            [self.textView.textStorage addAttribute:NSParagraphStyleAttributeName
                                              value:paragraphStyle
                                              range:paragraphRange];
        }
    }
}

# pragma mark - Paragraph Spacing Before

- (void)setParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore
{
    _paragraphSpacingBefore = paragraphSpacingBefore;
    self.beforeParagraphTextField.stringValue = [NSString stringWithFormat:@"%g pt", _paragraphSpacingBefore];
    [self.beforeParagraphStepper setFloatValue:_paragraphSpacingBefore];
}

- (IBAction)modifyParagraphSpacingBeforeAction:(id)sender
{
    [self setParagraphSpacingBefore:[sender floatValue]];
    
    NSArray * ranges = self.textView.selectedRanges;
    for (NSValue * value in ranges)
    {
        NSRange range = [value rangeValue];
        NSRange paragraphRange = [self.textView.textStorage.string paragraphRangeForRange:range];
        if (range.location < self.textView.string.length)
        {
            NSMutableParagraphStyle * paragraphStyle = [[self.textView.textStorage attribute:NSParagraphStyleAttributeName
                                                                                     atIndex:range.location
                                                                              effectiveRange:NULL] mutableCopy];
            [paragraphStyle setParagraphSpacingBefore:self.paragraphSpacingBefore];
            [self.textView.textStorage addAttribute:NSParagraphStyleAttributeName
                                              value:paragraphStyle
                                              range:paragraphRange];
        }
    }
}

# pragma mark - Paragraph Spacing After

- (void)setParagraphSpacingAfter:(CGFloat)paragraphSpacingAfter
{
    _paragraphSpacingAfter = paragraphSpacingAfter;
    self.afterParagraphTextField.stringValue = [NSString stringWithFormat:@"%g pt", _paragraphSpacingAfter];
    [self.afterParagraphStepper setFloatValue:_paragraphSpacingAfter];
}

- (IBAction)modifyParagraphSpacingAfterAction:(id)sender
{
    [self setParagraphSpacingAfter:[sender floatValue]];
    
    NSArray * ranges = self.textView.selectedRanges;
    for (NSValue * value in ranges)
    {
        NSRange range = [value rangeValue];
        NSRange paragraphRange = [self.textView.textStorage.string paragraphRangeForRange:range];
        if (range.location < self.textView.string.length)
        {
            NSMutableParagraphStyle * paragraphStyle = [[self.textView.textStorage attribute:NSParagraphStyleAttributeName
                                                                                     atIndex:range.location
                                                                              effectiveRange:NULL] mutableCopy];
            [paragraphStyle setParagraphSpacing:self.paragraphSpacingAfter];
            [self.textView.textStorage addAttribute:NSParagraphStyleAttributeName
                                              value:paragraphStyle
                                              range:paragraphRange];
        }
    }
}

# pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    NSNib * nib = [[NSNib alloc] initWithNibNamed:nibName
                                           bundle:nil];
    [self setTitle:title];
    NSArray * topLevelObjects;
    [nib instantiateWithOwner:self
              topLevelObjects:&topLevelObjects];
    
    for (id object in topLevelObjects) {
        if ([object isKindOfClass:[NSView class]] && [[object identifier] isEqualToString:viewID])
            [self setContentView:object];
    }
    return self;
}

- (id)initWithTextView:(TKOTextView *)textView
{
    self = [self init];
    
    [self setTextView:textView];
    
    return self;
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
                      selector:@selector(textViewDidChangeSpacing:)
                          name:NSTextViewDidChangeSelectionNotification
                        object:textView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
