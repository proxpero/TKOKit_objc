//
//  TKOChoicesEditorView.m
//  ProblemEditor
//
//  Created by Todd Olsen on 6/9/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOChoicesEditorView.h"
#import "TKOProblemEditorTextView.h"
#import "TKOListItemView.h"

#import "NSView+TKOKit.h"

@interface TKOChoicesEditorView () <NSTextViewDelegate>

@property (nonatomic) NSMutableArray * items;
@property (nonatomic) NSString * html;

@end

@implementation TKOChoicesEditorView
{
    NSView * firstKeyView;
    NSView * lastKeyView;
}


- (instancetype)init
{
    self = [super initWithFrame:NSZeroRect];
    if (!self) return nil;
    
    self.wantsLayer = YES;
    self.layer.backgroundColor = [[NSColor whiteColor] CGColor];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.items = [NSMutableArray new];
    
    NSFont * font = [NSFont fontWithName:@"Baskerville" size:20];
    TKOListItemMetricsHelper * choiceMetrics = [[TKOListItemMetricsHelper alloc] initWithPlaceholder:@"New Choice Item" font:font widthOffset:7 heightOffset:7 itemIndent:54];
    [self.items addObject:[TKOListItemView itemWithMetrics:choiceMetrics]];
    [self.items addObject:[TKOListItemView itemWithMetrics:choiceMetrics]];
    [self.items addObject:[TKOListItemView itemWithMetrics:choiceMetrics]];
    [self.items addObject:[TKOListItemView itemWithMetrics:choiceMetrics]];
    [self.items addObject:[TKOListItemView itemWithMetrics:choiceMetrics]];
    
    firstKeyView = [self.items.firstObject textView];
    
    [self layoutItems];
    
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
                                       constant:(prev ? 0 : 13)]
         ];
        
        oneItem.textView.delegate = self;
        if (prev) [prev.textView setNextKeyView:oneItem.textView];
        prev = oneItem;
        
        NSString * itemLabel = [NSString stringWithFormat:@"(%c)", 'A' + (char)idx];
        oneItem.label.stringValue = itemLabel;        
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
                                       constant:13]
         ];
        lastKeyView = prev.textView;
    }
}


#pragma mark - Text View Delegate

- (void)textDidChange:(NSNotification *)notification
{
    NSMutableString * html = [NSMutableString new];
    [html appendString:@"<ol class='choices'>\n"];
    for (TKOListItemView * liv in self.items) {
        [html appendFormat:@"\t<li>%@</li>\n", liv.textView.string];
    }
    [html appendString:@"</ol><!-- choices -->\n"];
    self.html = html.copy;
}

#pragma mark - Component Delegate

- (NSView *)firstKeyView { return firstKeyView; }
- (NSView *)lastKeyView  { return lastKeyView; }

@end
