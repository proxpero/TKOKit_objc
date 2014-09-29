//
//  TKOSegmentedControlView.m
//  TKOSegmentedControlDemo
//
//  Created by Todd Olsen on 6/26/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOSegmentedControlView.h"
#import "TKOSegmentedItem.h"
#import "TKOThemeLoader.h"
#import "TKOTheme.h"
#import "TKOButtonCell.h"
#import "TKOThemeConstants.h"

@interface TKOSegmentedControlView ()

@end

@implementation TKOSegmentedControlView

- (void)addItemWithWithLabel:(NSString *)label image:(NSImage *)image tag:(NSInteger)tag
{
    TKOSegmentedItem * newItem = [[TKOSegmentedItem alloc] initWithLabel:label
                                                                   image:image
                                                                     tag:tag];
    [self.items addObject:newItem];
    [self layoutItems];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self layoutItems];
    
    return self;
}


- (void)awakeFromNib
{
    [self layoutItems];
}


- (void)setItems:(NSMutableArray *)items
{
    if (_items == items) return;
    _items = items;
    [self layoutItems];
}


- (void)layoutItems
{
    if (!self.theme) {
        TKOThemeLoader * themeLoader = [[TKOThemeLoader alloc] init];
        self.theme = [themeLoader themeNamed:@"TKOSegmentedControl"];
    }
    
    [self removeConstraints:self.constraints];
    NSMutableArray * buttons = [NSMutableArray new];
    
    for (NSDictionary * item in self.items) {
        [buttons addObject:[self buttonForItem:item]];
    }
    
    [self setSubviews:buttons];
    
    NSButton * prev = nil;
    for (NSButton * button in buttons) {
        
        [button setContentCompressionResistancePriority:NSLayoutPriorityRequired
                                         forOrientation:NSLayoutConstraintOrientationHorizontal];
        
//        [button addConstraint:
//         [NSLayoutConstraint constraintWithItem:button
//                                      attribute:NSLayoutAttributeWidth
//                                      relatedBy:NSLayoutRelationGreaterThanOrEqual
//                                         toItem:nil
//                                      attribute:0
//                                     multiplier:1
//                                       constant:40]
//         ];
//
//        [button addConstraint:
//         [NSLayoutConstraint constraintWithItem:button
//                                      attribute:NSLayoutAttributeWidth
//                                      relatedBy:NSLayoutRelationLessThanOrEqual
//                                         toItem:nil
//                                      attribute:0
//                                     multiplier:1
//                                       constant:200]
//         ];
        
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|"
                                                 options:0
                                                 metrics:nil
                                                   views:NSDictionaryOfVariableBindings(button)]
         ];
        
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:button
                                      attribute:NSLayoutAttributeLeading
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:prev != nil ? prev : self
                                      attribute:prev != nil ? NSLayoutAttributeTrailing : NSLayoutAttributeLeading
                                     multiplier:1
                                       constant:0]
         ];
        
        if (prev) {
            [self addConstraint:
             [NSLayoutConstraint constraintWithItem:button
                                          attribute:NSLayoutAttributeWidth
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:prev
                                          attribute:NSLayoutAttributeWidth
                                         multiplier:1
                                           constant:0]
             ];
            
        }
        
        prev = button;
    }
    
    if (prev) {
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:prev
                                      attribute:NSLayoutAttributeTrailing
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self
                                      attribute:NSLayoutAttributeTrailing
                                     multiplier:1
                                       constant:1]
         ];
    }
}


- (NSButton *)buttonForItem:(NSDictionary *)item
{
    NSButton * button = [[NSButton alloc] init];
    button.translatesAutoresizingMaskIntoConstraints = NO;

    CGFloat height = [self.theme floatForKey:TKOControlHeight];
    
    button.identifier = item[TKOSidebarItemLabelKey];
    [button addConstraint:
     [NSLayoutConstraint constraintWithItem:button
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:height]
     ];
    
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
    cell.action = @selector(selectSegment:);
    
    [self applyThemeToCell:cell];
    
    button.cell = cell;
    
    return button;
}

- (void)applyThemeToCell:(TKOButtonCell *)cell
{
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
    
    cell.borderMask = TKOBorderMaskBottom|TKOBorderMaskRight;
    cell.borderHighlightMask = TKOBorderMaskBottom|TKOBorderMaskRight;
}

- (void)selectSegment:(id)sender
{
    NSButton * selectedButton = sender;
    for (NSButton * button in self.subviews) {
        button.state = (button == selectedButton) ? 1 : 0;
    }
    self.selectedTag = selectedButton.tag;
    self.selectedIndex = [self.subviews indexOfObject:selectedButton];
    self.selectedIdentifier = selectedButton.identifier;
    
    [[NSApplication sharedApplication] sendAction:self.action
                                               to:self.target
                                             from:self];
    
    [self invalidateRestorableState];
}


@end




