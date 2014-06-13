//
//  TKOComponentEditorListView.m
//  ProblemEditor
//
//  Created by Todd Olsen on 6/12/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOComponentEditorListView.h"
#import "TKOProblemEditorTextView.h"
#import "TKOListItemView.h"

#import "TKOThemeLoader.h"
#import "TKOTheme.h"

#import "NSView+TKOKit.h"

@interface TKOComponentEditorListView () <NSTextViewDelegate>

@property (nonatomic) NSMutableArray * items;
@property (nonatomic) NSView * firstKeyView;
@property (nonatomic) NSView * lastKeyView;

@end

@implementation TKOComponentEditorListView

- (instancetype)initWithPlaceholder:(NSString *)placeholder
                              count:(NSUInteger)count
                       markerFormat:(NSString *)markerFormat
                       markerIndent:(CGFloat)markerIndent
{
    self = [super initWithFrame:NSZeroRect];
    if (!self) return nil;
    
    self.wantsLayer = YES;
    self.layer.backgroundColor = [[NSColor whiteColor] CGColor];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    _items = [NSMutableArray new];
    self.formatMarker = markerFormat;
    
    TKOThemeLoader * themeLoader = [[TKOThemeLoader alloc] init];
    TKOTheme * theme             = [themeLoader defaultTheme];
    
    NSFont * font                = [theme fontForKey:@"TKOProblemEditorFont"];
    
    for (NSInteger i = 0; i < count; i++)
    {
        [self.items addObject:[TKOListItemView itemWithPlaceholder:placeholder
                                                              font:font
                                                        itemIndent:markerIndent]];
    }
    
    _firstKeyView = [self.items.firstObject textView];
        
    return self;
}

- (void)layoutItems
{
    NSArray * items = self.items.copy;
    [self removeConstraints:self.constraints];
    [self setSubviews:items];
    __block TKOListItemView * prev = nil;
    
    [items enumerateObjectsUsingBlock:^(TKOListItemView * oneItem, NSUInteger idx, BOOL *stop) {
        
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
                                       constant:(prev ? 0 : (oneItem.textView.font.pointSize - oneItem.textView.textContainerInset.height))]
         ];
        
        if (prev) [prev.textView setNextKeyView:oneItem.textView];
        prev = oneItem;
        
        
        
        oneItem.label.stringValue = [NSString stringWithFormat:self.formatMarker, self.bullets[idx]];
        oneItem.textView.delegate = self;
        
    }];
    
    if (prev)
    {
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:self
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:prev
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                       constant:(prev.textView.font.pointSize - prev.textView.textContainerInset.height)]
         ];
        self.lastKeyView = prev.textView;
    }
}

#pragma mark - Text View Delegate

- (void)updateHtmlWithString:(NSString *)string
{
    NSAssert(1, @"Subclasses must override");
}

- (void)textDidChange:(NSNotification *)notification
{
    NSMutableString * html = [NSMutableString new];
    for (TKOListItemView * liv in self.items) {
        [html appendFormat:@"\t<li>%@</li>\n", liv.textView.string];
    }
    [self updateHtmlWithString:html.copy];
    [[NSNotificationCenter defaultCenter] postNotificationName:TKOComponentDidUpdateHtmlNotification object:self];
    
}

#pragma mark - Component Delegate

- (NSView *)firstKeyView { return _firstKeyView; }
- (NSView *)lastKeyView { return _lastKeyView; }

@end
