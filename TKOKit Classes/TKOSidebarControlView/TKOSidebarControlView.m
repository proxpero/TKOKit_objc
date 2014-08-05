//
//  TKOSidebarControlView.m
//  TKOSidebarControlView
//
//  Created by Todd Olsen on 6/29/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOSidebarControlView.h"
#import "TKOThemeLoader.h"
#import "TKOTheme.h"
#import "TKOThemeConstants.h"
#import "TKOButtonCell.h"

@implementation TKOSidebarControlView


- (void)layoutItems
{
    if (!self.theme) {
        TKOThemeLoader * themeLoader = [[TKOThemeLoader alloc] init];
        self.theme = [themeLoader defaultTheme];
    }
    
    [self removeConstraints:self.constraints];
    NSMutableArray * buttons = [NSMutableArray new];
    
    for (NSDictionary * item in self.items) {
        NSButton * button = [self buttonForItem:item];
        CGFloat height = [self.theme floatForKey:TKOSidebarControlHeight];
        if (height > 0) {
            [button addConstraint:
             [NSLayoutConstraint constraintWithItem:button
                                          attribute:NSLayoutAttributeHeight
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:nil
                                          attribute:NSLayoutAttributeNotAnAttribute
                                         multiplier:1
                                           constant:height]
             ];
        }
        [buttons addObject:button];
    }
    
    [self setSubviews:buttons];
    
    NSButton * prev = nil;
    for (NSButton * button in buttons) {
        
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button]|"
                                                 options:0
                                                 metrics:nil
                                                   views:NSDictionaryOfVariableBindings(button)]
         ];
        
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:button
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:prev != nil ? prev : self
                                      attribute:prev != nil ? NSLayoutAttributeBottom : NSLayoutAttributeTop
                                     multiplier:1
                                       constant:0]
         ];
        prev = button;
    }
    if (prev) {
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:prev
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                       constant:0]
         ];
    }
}

- (void)applyThemeToCell:(TKOButtonCell *)cell
{
    cell.verticalTextOffset = [self.theme floatForKey:TKOSidebarControlVerticalTextOffset];
    cell.verticalImageOffset = [self.theme floatForKey:TKOSidebarControlVerticalImageOffset];
    
    cell.backgroundGradient = [self.theme colorGradientForKey:TKOSidebarControlBackgroundGradient];
    cell.backgroundHighlightGradient = [self.theme colorGradientForKey:TKOSidebarControlBackgroundHighlightGradient];
    
    cell.font                     = [self.theme  fontForKey:TKOSidebarControlFont];
    cell.backgroundColor          = [self.theme colorForKey:TKOSidebarControlBackgroundColor];
    cell.backgroundHighlightColor = [self.theme colorForKey:TKOSidebarControlBackgroundHighlightColor];
    cell.textColor                = [self.theme colorForKey:TKOSidebarControlTextColor];
    cell.textHighlightColor       = [self.theme colorForKey:TKOSidebarControlTextHighlightColor];
    cell.imageColor               = [self.theme colorForKey:TKOSidebarControlImageColor];
    cell.imageHighlightColor      = [self.theme colorForKey:TKOSidebarControlImageHighlightColor];
    cell.borderColor              = [self.theme colorForKey:TKOSidebarControlBorderColor];
    cell.borderHighlightColor     = [self.theme colorForKey:TKOSidebarControlBorderHighlightColor];
    cell.gradientAngle            = [self.theme floatForKey:TKOSidebarControlGradientAngle];
    
    cell.borderMask = TKOBorderMaskBottom;
}

@end
