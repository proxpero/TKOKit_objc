//
//  TKOTextStorage.m
//  CoreDataAttributedString
//
//  Created by Todd Olsen on 6/25/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "TKOTextStorage.h"
#import "TKOTextView.h"
#import "TKOTextContainer.h"
#import "TKOLayoutManager.h"

NSString * const TKODefaultTokenName = @"TKODefaultTokenName";

@implementation TKOTextStorage
{
    NSMutableAttributedString * _backingStore;
    BOOL _dynamicTextNeedsUpdate;
}

- (id)initWithTextView:(TKOTextView *)textView
{
    self = [self init];
    
    TKOLayoutManager * layoutManager = [[TKOLayoutManager alloc] init];
    [self addLayoutManager:layoutManager];
    TKOTextContainer * textContainer = [[TKOTextContainer alloc] init];
    [layoutManager addTextContainer:textContainer];
    [textContainer setTextView:textView];
    
    return self;
}

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    _backingStore = [[NSMutableAttributedString alloc] init];
    
    return self;
}

# pragma mark - Overriding four privitive methods to subclass NSTextStorage
// https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/TextStorageLayer/Tasks/Subclassing.html

- (NSString *)string
{
    return [_backingStore string];
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location
                     effectiveRange:(NSRangePointer)range
{
    return [_backingStore attributesAtIndex:location
                             effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range
                      withString:(NSString *)str
{
    [self beginEditing];
    [_backingStore replaceCharactersInRange:range
                                 withString:str];
    [self edited:NSTextStorageEditedCharacters|NSTextStorageEditedAttributes
           range:range
  changeInLength:str.length - range.length];
    
    _dynamicTextNeedsUpdate = YES;
    [self endEditing];
}

- (void)setAttributes:(NSDictionary *)attrs
                range:(NSRange)range
{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self beginEditing];
    [_backingStore setAttributes:attrs
                           range:range];
    [self edited:NSTextStorageEditedAttributes
           range:range
  changeInLength:0];
    [self endEditing];
}

# pragma mark - Text Storage Override

- (void)processEditing
{
    if (_dynamicTextNeedsUpdate) {
        _dynamicTextNeedsUpdate = NO;
        [self performReplacementsForCharacterChangeInRange:[self editedRange]];
    }
    [super processEditing];
}

# pragma mark - Custom Methods

- (void)performReplacementsForCharacterChangeInRange:(NSRange)changedRange
{
    NSRange extendedRange;
    extendedRange = NSUnionRange(changedRange, [[_backingStore string] lineRangeForRange:NSMakeRange(changedRange.location, 0)]);
    extendedRange = NSUnionRange(changedRange, [[_backingStore string] lineRangeForRange:NSMakeRange(NSMaxRange(changedRange), 0)]);
//    [self applyTextListMarkersToRange:extendedRange];
//    [self applyTokenAttributesToRange:extendedRange];
}

- (void)applyTextListMarkersToRange:(NSRange)searchRange
{

}

- (void)applyTokenAttributesToRange:(NSRange)searchRange
{
    [[_backingStore string] enumerateSubstringsInRange:searchRange
                                               options:NSStringEnumerationByWords
                                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                            
                                                NSLog(@"%@", substring);
                                                
                                            
                                            }];
}

@end
