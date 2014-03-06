//
//  TKOListsInspectorViewController.m
//  TKOListAndBulletsInspectorDemo
//
//  Created by Todd Olsen on 2/14/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOListsInspectorViewController.h"
#import "TKOTextSystem.h"

static NSDictionary * numericalMarkers = nil;
static NSDictionary * bulletMarkers = nil;

//check
//circle
//diamond
//disc
//hyphen
//square
//lower-hexadecimal
//upper-hexadecimal
//octal
//lower-alpha or lower-latin
//upper-alpha or upper-latin
//lower-roman
//upper-roman
//decimal

@interface TKOListsInspectorViewController ()

@property (nonatomic) CGFloat numberIndent;
@property (strong, nonatomic) NSTextTab * numberIndentTextTab;
@property (nonatomic) CGFloat textIndent;
@property (strong, nonatomic) NSTextTab * textIndentTextTab;
@property (nonatomic) BOOL tieredNumbers;
@property (nonatomic) NSInteger startFrom;

- (IBAction)selectedListTypeAction:(id)sender;
- (IBAction)sendNumberIndentAction:(id)sender;
- (IBAction)sendTextIndentAction:(id)sender;

@end

NSString * listTitle = @"Bullets & Lists";
NSString * listNibName = @"TKOListsInspectorViewController";
NSString * listViewID = @"TKOListContentViewIdentifier";

@implementation TKOListsInspectorViewController

# pragma mark - Lifecycle

+ (void)initialize
{
    if (!bulletMarkers) {
        bulletMarkers = @{
                             @"box": @"■",
                             @"check": @"✓",
                             @"circle": @"○",
                             @"diamond": @"⬦",
                             @"hyphen": @"－",
                             @"square": @"◻︎",
                             };
    }
    if (!numericalMarkers) {
        numericalMarkers = @{
                             @"lower-alpha": @"a, b, c",
                             @"upper-alpha": @"A, B, C",
                             @"lower-roman": @"i, ii, iii",
                             @"upper-roman": @"I, II, III",
                             @"decimal": @"1, 2, 3",
                             };
    }
}

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    NSNib * nib = [[NSNib alloc] initWithNibNamed:listNibName
                                           bundle:nil];
    [self setTitle:listTitle];
    NSArray * topLevelObjects;
    [nib instantiateWithOwner:self
              topLevelObjects:&topLevelObjects];
    
    for (id object in topLevelObjects) {
        if ([object isKindOfClass:[NSView class]] && [[object identifier] isEqualToString:listViewID])
            [self setContentView:object];
    }
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateListAttributes:)
                                                 name:NSTextViewDidChangeSelectionNotification
                                               object:_textView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateTextAttributes
{

}


# pragma mark - Properties

- (void)setNumberIndent:(CGFloat)numberIndent
{
    if (_numberIndent == numberIndent)
        return;
    
    [self willChangeValueForKey:@"numberIndent"];
    _numberIndent = numberIndent;
    [self didChangeValueForKey:@"numberIndent"];
    
//    NSArray * ranges = self.textView.selectedRanges;
//    for (NSValue * value in ranges)
//    {
//        NSRange range = [value rangeValue];
//        NSRange paragraphRange = [self.textView.textStorage.string paragraphRangeForRange:range];
//        if (range.location < self.textView.string.length) {
//            
//            NSMutableParagraphStyle * paragraphStyle = [[self.textView.textStorage attribute:NSParagraphStyleAttributeName
//                                                                                     atIndex:range.location
//                                                                              effectiveRange:NULL] mutableCopy];
//            
//            [paragraphStyle add]
//            [self.textView.textStorage addAttribute:NSParagraphStyleAttributeName
//                                              value:paragraphStyle
//                                              range:paragraphRange];
//        }
//    }
    
    
}

- (void)updateListAttributes:(NSNotification *)notification
{
    NSArray * textLists;
    NSArray * ranges = [self.textView selectedRanges];
    
    for (NSValue * range in ranges)
    {
        NSInteger location = [range rangeValue].location;
        if (location != NSNotFound && location < self.textView.textStorage.length)
        {
            NSParagraphStyle * paragraphStyle = [self.textView.textStorage attribute:NSParagraphStyleAttributeName
                                                                             atIndex:location
                                                                      effectiveRange:NULL];
            textLists = [paragraphStyle textLists];
            NSTextList * textList = textLists.firstObject;
            NSString * marker  = [textList markerFormat];
            NSUInteger options = [textList listOptions];
            NSLog(@"marker %@, options %lu", marker, options);
            NSLog(@"paragraph style: %@", paragraphStyle);
        }
    }
}

- (IBAction)selectedListTypeAction:(id)sender
{
    NSMutableParagraphStyle * paragraphStyle;
    if ([[sender selectedItem] tag] == 1)
    {
        NSInteger location = self.textView.selectedRange.location;
        if (location != NSNotFound && location < self.textView.textStorage.length)
        {
            paragraphStyle = [[self.textView.textStorage attribute:NSParagraphStyleAttributeName
                                                           atIndex:location
                                                    effectiveRange:NULL] mutableCopy];
            if (!paragraphStyle.tabStops.count)
            {
                NSTextList * textList = [[NSTextList alloc] initWithMarkerFormat:@"({upper-alpha})"
                                                                         options:0];
                self.numberIndentTextTab = [[NSTextTab alloc] initWithType:NSLeftTabStopType location:0.0];
                self.textIndentTextTab   = [[NSTextTab alloc] initWithType:NSLeftTabStopType location:36.0];
                [paragraphStyle addTabStop:self.numberIndentTextTab];
                [paragraphStyle addTabStop:self.textIndentTextTab];
                [paragraphStyle setHeadIndent:36.0];
                [paragraphStyle setTextLists:@[textList]];
                
                NSRange range = [self.textView rangeForUserParagraphAttributeChange];
                [self.textView.textStorage addAttribute:NSParagraphStyleAttributeName
                                                  value:paragraphStyle
                                                  range:range];
                
                NSString * marker = [NSString stringWithFormat:@"\t%@\t", [textList markerForItemNumber:1]];
                NSDictionary * attributes = [self.textView.textStorage attributesAtIndex:range.location
                                                                          effectiveRange:NULL];
                [self.textView.textStorage insertAttributedString:[[NSAttributedString alloc] initWithString:marker
                                                                                                  attributes:attributes]
                                                          atIndex:range.location];
            }
        }
    }
    NSLog(@"paragraph style: %@", paragraphStyle);
}

- (IBAction)sendNumberIndentAction:(id)sender
{
    
}

- (IBAction)sendTextIndentAction:(id)sender
{
    
}

@end
