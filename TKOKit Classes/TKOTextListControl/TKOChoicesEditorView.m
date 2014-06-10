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

@interface TKOChoicesEditorView ()
@property (nonatomic) NSMutableArray * items;


@end

@implementation TKOChoicesEditorView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (!self) return nil;
    
    self.wantsLayer = YES;
    self.layer.backgroundColor = [[NSColor whiteColor] CGColor];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.items = [NSMutableArray new];
    
    NSFont * font = [NSFont fontWithName:@"Baskerville" size:20];
    TKOListItemMetricsHelper * choiceMetrics = [[TKOListItemMetricsHelper alloc] initWithPlaceholder:@"New Choice Item" font:font widthOffset:7 heightOffset:7 itemIndent:40];
    [self.items addObject:[TKOListItemView itemWithMetrics:choiceMetrics]];
    [self.items addObject:[TKOListItemView itemWithMetrics:choiceMetrics]];
    [self.items addObject:[TKOListItemView itemWithMetrics:choiceMetrics]];
    [self.items addObject:[TKOListItemView itemWithMetrics:choiceMetrics]];
    [self.items addObject:[TKOListItemView itemWithMetrics:choiceMetrics]];
    
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
        
        if (prev) [prev setNextKeyView:oneItem];
        prev = oneItem;
        
        NSString * itemLabel = [NSString stringWithFormat:@"(%c)", 'A' + (char)idx];
        oneItem.label.stringValue = itemLabel;
        oneItem.flowDelegate = self; // this should go in elsewhere
        
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
    }
}

- (BOOL)becomeFirstResponder
{
    [self.window makeFirstResponder:[self.items.firstObject textView]];
    return NO;
}

- (BOOL)componentShouldGoUp:(id)componentView
{
    NSUInteger index = [self.items indexOfObject:componentView];
    if (index == 0) return [self.flowDelegate componentShouldGoUp:self];
    
    TKOListItemView * upItem = self.items[index - 1];
    [self.window makeFirstResponder:upItem.textView];
    
    return NO;
}

- (BOOL)componentShouldGoDown:(id)componentView
{
    NSUInteger index = [self.items indexOfObject:componentView];
    if (index == self.items.count - 1) return [self.flowDelegate componentShouldGoDown:self];
    
    TKOListItemView * nextItem = self.items[index + 1];
    [self.window makeFirstResponder:nextItem.textView];
    
    return NO;
}

- (NSResponder *)topResponder
{
    return self.items.firstObject;
}
- (NSResponder *)bottomResponder
{
    return self.items.lastObject;
}


@end
