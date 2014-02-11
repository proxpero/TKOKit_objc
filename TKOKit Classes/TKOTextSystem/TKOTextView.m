//
//  TKOTextView.m
//  TextEditor
//
//  Created by Todd Olsen on 7/17/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "TKOTextView.h"
#import "TKOTextStorage.h"
#import "TKOTextContainer.h"
#import "TKOLayoutManager.h"

//#import "TKOFontInspectorViewController.h"

@implementation TKOTextView

- (id)init
{
    if ( !(self = [super init])) return nil;
    NSLog(@"Error: %s", __PRETTY_FUNCTION__);
    return nil;
}

- (id)initWithFrame:(NSRect)frameRect
{
    if (!(self = [super initWithFrame:frameRect])) return nil;
    NSLog(@"Error: %s", __PRETTY_FUNCTION__);
    return nil;
}

- (id)initWithFrame:(NSRect)frameRect
      textContainer:(NSTextContainer *)container
{
    self = [super initWithFrame:frameRect
                  textContainer:container];
    if (!self)
        return nil;
    
    [self configureTextView];
    
    return self;
}

//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//    if (!self)
//        return nil;
//
//    _textStorage = [[TKOTextStorage alloc] init];
//    TKOLayoutManager * layoutManager = [[TKOLayoutManager alloc] init];
//    [_textStorage addLayoutManager:layoutManager];
//    
//    TKOTextContainer * textContainer = [[TKOTextContainer alloc] init];
//    [layoutManager addTextContainer:textContainer];
//    
//    [textContainer setTextView:self];
//    [self configureTextView];
//
//    return self;
//}

- (void)setFontDelegate:(id<TKOTextViewFontDelegate>)fontDelegate
{
    if (_fontDelegate == fontDelegate)
        return;
    
    NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
    
    if (_fontDelegate && [_fontDelegate respondsToSelector:@selector(textViewDidChangeFont:)])
        [defaultCenter removeObserver:_fontDelegate
                                 name:TKOTextViewDidChangeFontNotification
                               object:self];
    _fontDelegate = fontDelegate;
    if (_fontDelegate && [_fontDelegate respondsToSelector:@selector(textViewDidChangeFont:)])
        [defaultCenter addObserver:_fontDelegate
                          selector:@selector(textViewDidChangeFont:)
                              name:TKOTextViewDidChangeFontNotification
                            object:self];
}

- (void)configureTextView
{
    [self setTextContainerInset:NSMakeSize(20, 20)];
    [self setMinSize:NSMakeSize(0.0, 0.0)];
    [self setMaxSize:NSMakeSize(FLT_MAX, FLT_MAX)];
    [self setVerticallyResizable:YES];
    [self setHorizontallyResizable:YES];
    [self setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    
    // Behavioral Attributes
    [self setAllowsUndo:YES];
    [self setEditable:YES];
    [self setSelectable:YES];
    [self setRichText:YES];
    [self setImportsGraphics:YES];
    [self setAllowsImageEditing:NO];
    [self setAutomaticQuoteSubstitutionEnabled:YES];
    [self setAutomaticDashSubstitutionEnabled:YES];
    [self setAutomaticSpellingCorrectionEnabled:YES];
    [self setAutomaticTextReplacementEnabled:YES];
    
    // Text Formatting Controls
    [self setUsesRuler:YES];
    [self setRulerVisible:NO];
    [self setUsesInspectorBar:NO];
}

- (void)updateFontPanel
{
    [super updateFontPanel];    
    NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter postNotificationName:TKOTextViewDidChangeFontNotification
                                 object:self];
}

- (void)fontInspectorDidModifyFontFamily:(NSString *)familyName
{
    NSFontManager * fontManager = [NSFontManager sharedFontManager];
    NSArray * ranges = [self selectedRanges];
    NSFont * oldFont = [fontManager selectedFont];
    NSFont * newFont = [fontManager convertFont:oldFont toFamily:familyName];
    
    for (NSValue * value in ranges) {
        NSRange range = [value rangeValue];
        [self.textStorage addAttribute:NSFontAttributeName
                                 value:newFont
                                 range:range];
    }
}

- (void)fontInspectorDidModifyFontFace:(NSString *)faceName
{
    NSFontManager * fontManager = [NSFontManager sharedFontManager];
    NSArray * ranges = [self selectedRanges];
    NSFont * oldFont = [fontManager selectedFont];
    NSFont * newFont = [fontManager convertFont:oldFont toFace:faceName];
    
    for (NSValue * value in ranges) {
        NSRange range = [value rangeValue];
        [self.textStorage addAttribute:NSFontAttributeName
                                 value:newFont
                                 range:range];
    }
}

- (void)fontInspectorDidModifyFontSize:(CGFloat)size
{
    NSFontManager * fontManager = [NSFontManager sharedFontManager];
    NSArray * ranges = [self selectedRanges];
    NSFont * oldFont = [fontManager selectedFont];
    NSFont * newFont = [fontManager convertFont:oldFont toSize:size];
    
    for (NSValue * value in ranges) {
        NSRange range = [value rangeValue];
        [self.textStorage addAttribute:NSFontAttributeName
                                 value:newFont
                                 range:range];
    }
}

- (void)fontInspectorDidModifyBoldness:(BOOL)isBold
{
    NSFontManager * fontManager = [NSFontManager sharedFontManager];
    NSArray * ranges = [self selectedRanges];
    NSFont * oldFont = [fontManager selectedFont];
    NSFont * newFont = [fontManager convertFont:oldFont toHaveTrait:isBold ? NSBoldFontMask : NSUnboldFontMask];
    
    for (NSValue * value in ranges) {
        NSRange range = [value rangeValue];
        [self.textStorage addAttribute:NSFontAttributeName
                                 value:newFont
                                 range:range];
    }
}

- (void)fontInspectorDidModifyObliquity:(BOOL)isOblique
{
    NSFontManager * fontManager = [NSFontManager sharedFontManager];
    NSArray * ranges = [self selectedRanges];
    NSFont * oldFont = [fontManager selectedFont];
    NSFont * newFont = [fontManager convertFont:oldFont toHaveTrait:isOblique ? NSItalicFontMask : NSUnitalicFontMask];
    
    for (NSValue * value in ranges) {
        NSRange range = [value rangeValue];
        [self.textStorage addAttribute:NSFontAttributeName
                                 value:newFont
                                 range:range];
    }
}

- (void)fontInspectorDidModifyUnderlining:(BOOL)isUnderlined
{
    NSInteger underlining = isUnderlined ? (NSUnderlinePatternSolid|NSUnderlineStyleSingle) : 0;
    NSArray * ranges = [self selectedRanges];
    for (NSValue * value in ranges) {
        NSRange range = [value rangeValue];
        [self.textStorage addAttribute:NSUnderlineStyleAttributeName
                                 value:@(underlining)
                                 range:range];
    }
}

- (void)fontInspectorDidModifyTextColor:(NSColor *)color
{
    NSArray * ranges = [self selectedRanges];
    for (NSValue * value in ranges) {
        NSRange range = [value rangeValue];
        [self.textStorage addAttribute:NSForegroundColorAttributeName
                                 value:color
                                 range:range];
    }
}

- (BOOL)isOpaque {
    return YES;
}
- (BOOL)isFlipped {
    return YES;
}

@end

NSString * TKOTextViewDidChangeFontNotification = @"TKOTextViewDidChangeFontNotification";
