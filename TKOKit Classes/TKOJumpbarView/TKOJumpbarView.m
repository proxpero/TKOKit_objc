//
//  TKOJumpbarView.m
//  TKOFormatViewControllerDemo
//
//  Created by Todd Olsen on 7/7/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOJumpbarView.h"
#import "TKOThemeLoader.h"
#import "TKOTheme.h"
#import "NSView+TKOKit.h"
#import "TKOButtonCell.h"

@interface TKOJumpbarView ()

@property (nonatomic) TKOTheme * theme;
@property (nonatomic) NSGradient * gradient;

@property (nonatomic) NSScrollView * scrollView;

@end


@implementation TKOJumpbarView

- (id)init
{
    self = [super initWithFrame:NSZeroRect];
    if (!self) return nil;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self configure];
    
    return self;
}

- (void)setItem:(id)item
{
    if (_item == item) return;
    
    [_item removeObserver:self forKeyPath:@"name"];
    _item = item;
    [_item addObserver:self forKeyPath:@"name" options:0 context:NULL];
    
    [self layoutHierarchy];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"name"]) {
        [self layoutHierarchy];
    }
}


- (void)awakeFromNib
{
    [self configure];
}

- (void)configure
{
    static BOOL configured = NO; if (configured) return; configured = YES;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.wantsLayer = YES;
    TKOThemeLoader * themeloader = [[TKOThemeLoader alloc] init];
    self.theme = [themeloader themeNamed:@"TKOJumpbarControl"];
    
    [self addConstraintForHeight:28];

    NSButton * goLeftButton = [self buttonWithImage:[NSImage imageNamed:NSImageNameGoLeftTemplate]];
    NSButton * goRightButton = [self buttonWithImage:[NSImage imageNamed:NSImageNameGoRightTemplate]];
    
//    NSButton * previewButton = [[NSButton alloc] initWithFrame:NSZeroRect];
//    previewButton.translatesAutoresizingMaskIntoConstraints = NO;
//    previewButton.buttonType = NSMomentaryChangeButton;
//    previewButton.imagePosition = NSNoImage;
//    previewButton.title = @"Preview";
    
    _scrollView = [[NSScrollView alloc] initWithFrame:NSZeroRect];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView setUsesPredominantAxisScrolling:YES];
    _scrollView.drawsBackground = NO;
    _scrollView.wantsLayer = YES;
    
    self.subviews = @[goLeftButton, goRightButton, _scrollView];
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[goLeftButton(32)][goRightButton(32)][_scrollView]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(goLeftButton, goRightButton, _scrollView)
      ]
     ];
    
    for (NSView * view in self.subviews) {
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                 options:0
                                                 metrics:nil
                                                   views:NSDictionaryOfVariableBindings(view)]
         ];
    }
}

- (NSButton *)buttonWithImage:(NSImage *)image
{
    NSButton * button = [[NSButton alloc] initWithFrame:NSZeroRect];
    
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.bordered = NO;
    button.buttonType = NSMomentaryChangeButton;
    button.imagePosition = NSImageOnly;
    button.image = image;
    
    return button;
}


- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    NSRect main, border;
    NSDivideRect(self.bounds, &border, &main, 1.0, NSMinYEdge);
    
    NSColor * color = [_theme colorForKey:TKOControlBorderColor];
    [color set];
    NSRectFill(border);
    
    if (!self.gradient) {
        self.gradient = [_theme colorGradientForKey:TKOControlBackgroundGradient];
    }
    [self.gradient drawInRect:main angle:270.0];
}


- (void)layoutHierarchy
{
    NSView * tabView = [NSView viewWithClass:[NSView class]];
    
    id nomad = self.item;
    NSMutableArray * items = [NSMutableArray new];
    
    while (nomad) {
        [items addObject:nomad];
        nomad = [nomad valueForKey:@"parent"];
    }
    
    for (id item in [[items reverseObjectEnumerator] allObjects]) {
        NSButton * button = [self buttonWithItem:item];
        [tabView addSubview:button];
    }
    
    NSView * prev = nil;
    
    for (NSView * view in tabView.subviews) {
        [tabView addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                 options:0
                                                 metrics:nil
                                                   views:NSDictionaryOfVariableBindings(view)]
         ];
        [tabView addConstraint:
         [NSLayoutConstraint constraintWithItem:view
                                      attribute:NSLayoutAttributeLeading
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:prev ? prev : tabView
                                      attribute:prev ? NSLayoutAttributeTrailing : NSLayoutAttributeLeading
                                     multiplier:1
                                       constant:3]
         ];
        prev = view;
    }
    if (prev) {
        [tabView addConstraint:
         [NSLayoutConstraint constraintWithItem:prev
                                      attribute:NSLayoutAttributeTrailing
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:tabView
                                      attribute:NSLayoutAttributeTrailing
                                     multiplier:1
                                       constant:3]
         ];
    }
    [tabView layoutSubtreeIfNeeded];
    self.scrollView.documentView = tabView;
    if (self.scrollView.documentView) {
        NSClipView * clipView = self.scrollView.contentView;
        NSView * documentView = self.scrollView.documentView;
        
        [clipView addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:[documentView]|"
                                                 options:0
                                                 metrics:nil
                                                   views:@{@"documentView": documentView}]];
        [clipView addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[documentView]|"
                                                 options:0
                                                 metrics:nil
                                                   views:@{@"documentView": documentView}]];
    }
}


- (NSButton *)buttonWithItem:(id)item
{
    NSButton * button = [NSView viewWithClass:[NSButton class]];
    
    TKOButtonCell * cell = [[TKOButtonCell alloc] init];
//    [cell bind:@"title" toObject:item withKeyPath:@"name" options:nil];
    cell.title = [item valueForKey:@"name"];
    cell.buttonType = NSMomentaryChangeButton;
    cell.bordered = NO;

    cell.verticalTextOffset = [self.theme floatForKey:TKOControlVerticalTextOffset];
    cell.verticalImageOffset = [self.theme floatForKey:TKOControlVerticalImageOffset];
    
    cell.backgroundGradient = [self.theme colorGradientForKey:TKOControlBackgroundGradient];
    cell.backgroundHighlightGradient = [self.theme colorGradientForKey:TKOControlBackgroundHighlightGradient];
    
    cell.font                     = [self.theme fontForKey:TKOControlFont];
    cell.backgroundColor          = [self.theme colorForKey:TKOControlBackgroundColor];
    cell.backgroundHighlightColor = [self.theme colorForKey:TKOControlBackgroundHighlightColor];
    cell.textColor                = [self.theme colorForKey:TKOControlTextColor];
    cell.textHighlightColor       = [self.theme colorForKey:TKOControlTextHighlightColor];
    cell.imageColor               = [self.theme colorForKey:TKOControlImageColor];
    cell.imageHighlightColor      = [self.theme colorForKey:TKOControlImageHighlightColor];
    cell.borderColor              = [self.theme colorForKey:TKOControlBorderColor];
    cell.borderHighlightColor     = [self.theme colorForKey:TKOControlBorderHighlightColor];
    cell.gradientAngle            = [self.theme floatForKey:TKOControlGradientAngle];
    cell.verticalTextOffset       = [self.theme floatForKey:TKOControlVerticalTextOffset];
    
    cell.borderMask = TKOBorderMaskBottom;
    cell.borderHighlightMask = TKOBorderMaskBottom;

    button.cell = cell;
    
    CGFloat width = button.intrinsicContentSize.width + 16;
    [button addConstraint:
     [NSLayoutConstraint constraintWithItem:button
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:0
                                 multiplier:1
                                   constant:width]
     ];
    
    return button;
}

@end


