//
//  TKOProblemEditorListComponentView.m
//  Keystone
//
//  Created by Todd Olsen on 6/4/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOProblemEditorListComponentView.h"
#import "TKOTextListItem.h"
#import "NSView+TKOKit.h"

@interface TKOProblemEditorListComponentView ()

@property (nonatomic) NSString * placeholder;

@end

NSArray * Numerals = nil;
NSArray * numerals = nil;

static inline NSString * marker(TKOListMarkerFormat format, NSUInteger index) {
    
    if (!Numerals) Numerals = @[@"I", @"II", @"III", @"IV", @"V", @"VI", @"VII", @"VIII", @"IX", @"X"];
    if (!numerals) numerals = @[@"i", @"ii", @"iii", @"iv", @"v", @"vi", @"vii", @"viii", @"ix", @"x"];
    
    NSString * marker;
    
    switch (format) {
        case TKOListMarkerFormatUpperAlpha:
            marker = [NSString stringWithFormat:@"(%c)", 'A' + (char)index];
            break;
        case TKOListMarkerFormatLowerAlpha:
            marker = [NSString stringWithFormat:@"(%c)", 'a' + (char)index];
            break;
        case TKOListMarkerFormatUpperRoman:
            marker = [NSString stringWithFormat:@"%@.", Numerals[index]];
            break;
        case TKOListMarkerFormatLowerRoman:
            marker = [NSString stringWithFormat:@"%@.", numerals[index]];
            break;
        default:
            marker = @"";
            break;
    }
    
    return marker;
}

@implementation TKOProblemEditorListComponentView

- (instancetype)initWithFont:(NSFont *)font placeholder:(NSString *)placeholder listMarkerFormat:(TKOListMarkerFormat)listMarkerFormat
{
    self = [super initWithFrame:NSZeroRect];
    if (!self) return nil;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.items = [NSMutableArray new];
    [self.items addObject:[[TKOTextListItem alloc] init]];
    
    return self;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self reloadData];
    self.wantsLayer = YES;
    self.layer.backgroundColor = [[NSColor whiteColor] CGColor];
    
    return self;
}

- (void)setDatasource:(id<TKOTextListDataSource>)datasource
{
    if (_datasource == datasource) return;
    
    _datasource = datasource;
    [self reloadData];
}

- (void)reloadData
{
    NSMutableArray * newItems = [NSMutableArray new];
//    for (NSInteger i = 0, count = [self.datasource listControlNumberOfItems:self]; i < count; i++)
//    {
//        TKOTextListItem * item = [self.datasource listControl:self textListItemAtIndex:i];
//        item.textView.placeholderText = [self.datasource listControlPlaceholder:self];
//        item.label.stringValue = marker([self.datasource listControlMarkerFormatForItems:self], i);
//        item.delegate = self;
//        [newItems addObject:item];
//    }
    self.items = newItems.copy;
    [self layoutItems:self.items];
    
}

- (void)layoutItems:(NSArray *)items
{
    [self removeConstraints:self.constraints];
    [self setSubviews:items];
    TKOTextListItem * prev = nil;
    
    for (TKOTextListItem * oneItem in items)
    {
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[oneItem]|"
                                                 options:0
                                                 metrics:nil
                                                   views:@{@"oneItem":oneItem}]
         ];
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:oneItem
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:(prev ? prev : self)
                                      attribute:(prev ? NSLayoutAttributeBottom : NSLayoutAttributeTop)
                                     multiplier:1
                                       constant:(prev ? 0 : 5)]
         ];
        
        if (prev) [prev setNextKeyView:oneItem.textView];
        prev = oneItem;
    }
    
    if (prev)
    {
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:self
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:prev
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                       constant:5]
         ];
    }
}

- (void)textListItemWantsNewSibling:(NSNotification *)notification
{
//    [self.datasource listControl:self insertSiblingForListItem:[notification object]];
}

- (void)textListItemWantsAdvancement:(NSNotification *)notification
{
    TKOTextListItem * textListItem = [notification object];
    id next = [textListItem  nextKeyView];
    if ([next isKindOfClass:[TKOItemTextView class]]) {
        [next setSelectedRange:NSMakeRange(0, [next string].length)];
        [self.window makeFirstResponder:next];
    }
}

- (void)textListItemWantsPrevious:(NSNotification *)notification
{
//    TKOTextListItem * textListItem = [notification object];
//    NSInteger index = [self.items indexOfObject:textListItem];
//    if (index == NSNotFound || index == 0) return;
//
//    textListItem = self.items[index - 1];
//    [textListItem.textView setSelectedRange:NSMakeRange(0, textListItem.textView.string.length)];
//    [self.window makeFirstResponder:textListItem.textView];
}

- (void)deleteTextListItem:(NSNotification *)notification
{
//    if (self.items.count == 1) return; // Don't allow empty list
//    
//    TKOTextListItem * textListItem = [notification object];
//    NSInteger index = [self.items indexOfObject:textListItem];
//    if (index > 0) index--;
//    [self.datasource listControl:self removeItem:textListItem];
//    
//    textListItem = self.items[index];
//    [textListItem.textView setSelectedRange:NSMakeRange(0, textListItem.textView.string.length)];
//    [self.window makeFirstResponder:textListItem.textView];

}

@end
