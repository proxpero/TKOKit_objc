//
//  TKOStackingSidebarView.m
//  TKOStackingSidebarDemo
//
//  Created by Todd Olsen on 7/4/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOStackingSidebarView.h"


@implementation TKOStackingSidebarView


- (void)setItems:(NSArray *)items
{
    for (NSDictionary * item in items) {
        NSButton * button = [self buttonForItem:item];
        [self addView:button inGravity:[item[TKOSidebarItemGravityKey] integerValue]];
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button]|"
                                                 options:0
                                                 metrics:nil
                                                   views:NSDictionaryOfVariableBindings(button)]
         ];
    }
}


- (NSButton *)buttonForItem:(NSDictionary *)item
{
    NSButton * button = [[NSButton alloc] init];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    
    [button addConstraint:
     [NSLayoutConstraint constraintWithItem:button
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:self.buttonHeight]
     ];
    
    button.identifier = item[TKOSidebarItemLabelKey];
    
    TKOButtonCell * cell = [[TKOButtonCell alloc] init];
    
    cell.showsStateBy = NSChangeBackgroundCellMask;
    cell.highlightsBy = NSChangeBackgroundCellMask;
    
    cell.bordered = NO;
    cell.buttonType = NSMomentaryChangeButton;
    cell.title = item[TKOSidebarItemLabelKey];
    cell.image = item[TKOSidebarItemImageKey];
    
    if (cell.image == nil)
        cell.imagePosition = NSNoImage;
    else if (cell.title.length == 0)
        cell.imagePosition = NSImageOnly;
    else
        cell.imagePosition = NSImageAbove;
    
    
    cell.tag = [item[TKOSidebarItemTagKey] integerValue];
    cell.target = self;
    cell.action = @selector(selectItem:);
    
    [self applyThemeToCell:cell];
    
    if ([item[TKOSidebarItemGravityKey] integerValue] == NSStackViewGravityBottom) {
        cell.borderMask = TKOBorderMaskTop;
        cell.borderHighlightMask = TKOBorderMaskTop;
    }
    
    button.cell = cell;
    
    return button;
}


- (void)applyThemeToCell:(TKOButtonCell *)cell
{
    cell.verticalTextOffset = self.verticalTextOffset;
    cell.verticalImageOffset = self.verticalImageOffset;
    
    cell.backgroundGradient = self.backgroundGradient;
    cell.backgroundHighlightGradient = self.backgroundHighlightGradient;
    
    cell.font                     = self.font;
    cell.backgroundColor          = self.backgroundColor;
    cell.backgroundHighlightColor = self.backgroundHighlightColor;
    cell.textColor                = self.textColor;
    cell.textHighlightColor       = self.textHighlightColor;
    cell.imageColor               = self.imageColor;
    cell.imageHighlightColor      = self.imageHighlightColor;
    cell.borderColor              = self.borderColor;
    cell.borderHighlightColor     = self.borderHighlightColor;
    cell.gradientAngle            = self.gradientAngle;
    
    cell.borderMask = self.borderMask;
    cell.borderHighlightMask = self.borderMask;
}


- (void)selectItem:(id)sender
{
    NSButton * selectedButton = sender;
    for (NSButton * button in self.views) {
        button.state = (button == selectedButton) ? 1 : 0;
    }
    self.selectedTag = selectedButton.tag;
    self.selectedIndex = [self.subviews indexOfObject:selectedButton];
    self.selectedIdentifier = [selectedButton identifier];
    
    [[NSApplication sharedApplication] sendAction:self.action
                                               to:self.target
                                             from:self];
}


@end



