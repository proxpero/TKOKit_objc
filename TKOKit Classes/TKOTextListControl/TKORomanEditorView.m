//
//  TKORomanEditorView.m
//  ProblemEditor
//
//  Created by Todd Olsen on 6/9/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKORomanEditorView.h"
#import "TKOProblemEditorTextView.h"
#import "TKOListItemView.h"

#import "NSView+TKOKit.h"

@interface TKORomanEditorView ()

@property (nonatomic) NSMutableArray * items;
@property (nonatomic) TKOListItemMetricsHelper * metrics;

@end

@implementation TKORomanEditorView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (!self) return nil;
    
    self.wantsLayer = YES;
    self.layer.backgroundColor = [[NSColor whiteColor] CGColor];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    _items = [NSMutableArray new];
    
    NSFont * font = [NSFont fontWithName:@"Baskerville" size:20];
    _metrics = [[TKOListItemMetricsHelper alloc] initWithPlaceholder:@"New Roman Item" font:font widthOffset:7 heightOffset:7 itemIndent:75];
    [self.items addObject:[TKOListItemView itemWithMetrics:_metrics]];
    [self.items addObject:[TKOListItemView itemWithMetrics:_metrics]];
    [self.items addObject:[TKOListItemView itemWithMetrics:_metrics]];
    
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
        
        static NSArray * numerals = nil;
        if (!numerals) numerals = @[@"I", @"II", @"III", @"IV", @"V", @"VI", @"VII", @"VIII", @"IX", @"X"];
        
        oneItem.label.stringValue = [NSString stringWithFormat:@"%@.", numerals[idx]];
        
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

@end