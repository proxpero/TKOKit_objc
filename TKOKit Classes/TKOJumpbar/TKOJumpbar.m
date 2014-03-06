//
//  TKOJumpbar.m
//  Keystone
//
//  Created by Todd Olsen on 12/29/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "TKOJumpbar.h"
#import "TKOImageTabCell.h"
#import "TKOJumpbarCell.h"
#import "TKOImageTabCell.h"
#import "NSView+TKOKit.h"

@interface TKOJumpbar ()

@property (nonatomic, strong) NSArray       * items;
@property (nonatomic, strong) NSScrollView  * scrollView;

@property (nonatomic, strong) NSButton       * goBackButton,    * goForwardButton;
@property (strong, nonatomic) NSMutableArray * backwardHistory, * forwardHistory;

@end


@implementation TKOJumpbar
{
    id _selectedItem;
}

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (!self)
        return nil;
    
    [self configureSubviews];
    self.backwardHistory = [NSMutableArray new];
    self.forwardHistory = [NSMutableArray new];
    
    return self;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configureSubviews];
}


- (void)configureSubviews
{
    if (_scrollView != nil)
        return;
    
    [self.cell setTitle:@""];
    [self.cell setBorderMask:TKOBorderMaskBottom];
    [self.cell setFont:[NSFont fontWithName:@"LucidaGrande"
                                       size:11]];
    [self.cell setTarget:nil];
    [self.cell setAction:NULL];
    [self.cell setEnabled:NO];
    
    _scrollView = [NSView viewWithClass:[NSScrollView class]];
    [_scrollView setDrawsBackground:NO];
    [_scrollView setBackgroundColor:[NSColor redColor]];
    [_scrollView setHasHorizontalScroller:YES];

    [_scrollView setVerticalScrollElasticity:NSScrollElasticityNone];
    [_scrollView setHorizontalScrollElasticity:NSScrollElasticityAutomatic];
    

    _goBackButton       = [self buttonWithImageNamed:NSImageNameGoLeftTemplate
                                              target:self
                                              action:@selector(goBackAction:)];
    [_goBackButton setEnabled:NO];
    _goForwardButton    = [self buttonWithImageNamed:NSImageNameGoRightTemplate
                                              target:self
                                              action:@selector(goForwardAction:)];
    [_goForwardButton setEnabled:NO];
    
    NSDictionary * views = NSDictionaryOfVariableBindings(_goBackButton, _goForwardButton, _scrollView);
    [self setSubviews:views.allValues];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_goBackButton][_goForwardButton][_scrollView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:views]];
    for (NSView *view in views.allValues)
    {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:@{@"view": view}]];
    }
    
    [_goBackButton addConstraint:
     [NSLayoutConstraint constraintWithItem:_goBackButton
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:24]];
    [_goForwardButton addConstraint:
     [NSLayoutConstraint constraintWithItem:_goForwardButton
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:24]];
    [_scrollView setHasHorizontalScroller:NO];

}


- (NSButton *)buttonWithImageNamed:(NSString *)name
                            target:(id)target
                            action:(SEL)action
{
    NSButton *button = [NSView viewWithClass:[NSButton class]];
    
    TKOImageTabCell * cell = [[TKOImageTabCell alloc] initImageCell:[NSImage imageNamed:name]];
    [cell setBorderMask:TKOBorderMaskBottom];
    [cell setBorderHighlightColor:cell.borderColor];
    [button setCell:cell];
    
    [button setTarget:target];
    [button setAction:action];
    [button setEnabled:action != NULL];
    [button setImagePosition:NSImageOnly];
    
    return button;
}

#pragma mark - Properties

- (void)setBorderColor:(NSColor *)borderColor
{
    [self.cell setBorderColor:borderColor];
}


- (void)setBackgroundColor:(NSColor *)backgroundColor
{
    [self.cell setBackgroundColor:backgroundColor];
}

- (void)setDelegate:(id<TKOJumpbarDelegate>)delegate
{
    if (_delegate == delegate)
        return;
    
    if (_delegate && [_delegate respondsToSelector:@selector(jumpbarDidChangeSelection:)])
        [[NSNotificationCenter defaultCenter] removeObserver:_delegate
                                                        name:TKOJumpbarDidChangeSelectionNotification
                                                      object:self];
    _delegate = delegate;
    
    if (_delegate && [_delegate respondsToSelector:@selector(jumpbarDidChangeSelection:)])
        [[NSNotificationCenter defaultCenter] addObserver:_delegate
                                                 selector:@selector(jumpbarDidChangeSelection:)
                                                     name:TKOJumpbarDidChangeSelectionNotification
                                                   object:self];
}


- (void)layoutTabViewWithItems
{
    NSView * tabView = [NSView viewWithClass:[NSView class]];
    
    NSMutableArray * newTabs = [NSMutableArray new];
    
    NSUInteger i = 0;
    NSUInteger count = self.items.count;
    
    for (i = 0; i < count; i++)
    {
        id <TKOJumpbarItem> item = self.items[i];
        BOOL isLast = (i == count - 1);
        
        NSString * title = [item name];
        NSImage  * image = [[item class] image];
        Class clss = [item class];
        image = [clss valueForKey:@"image"];
        
        NSButton * button = [self tabWithTitle:title
                                         image:image
                                        isLast:isLast];
        
        [button.cell setRepresentedObject:item];
        [newTabs addObject:button];
    }
    
    [self layoutTabs:newTabs
              inView:tabView];
    
    self.scrollView.documentView = (self.items.count) ? tabView : nil;
    
    if (self.scrollView.documentView)
    {
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


- (void)layoutTabs:(NSArray *)tabs
            inView:(NSView *)tabView
{
    [tabView setSubviews:tabs];
    [tabView removeConstraints:tabView.constraints];
    
    NSButton * prev = nil;
    for (NSButton * button in tabs)
    {
        [tabView addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|"
                                                 options:0
                                                 metrics:nil
                                                   views:@{@"button": button}]];
        
        [tabView addConstraint:
         [NSLayoutConstraint constraintWithItem:button
                                      attribute:NSLayoutAttributeLeading
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:(prev != nil ? prev : tabView)
                                      attribute:(prev != nil ? NSLayoutAttributeTrailing : NSLayoutAttributeLeading)
                                     multiplier:1
                                       constant:0]];
        prev = button;
    }
    
    if (prev)
    {
        [tabView addConstraint:
         [NSLayoutConstraint constraintWithItem:prev
                                      attribute:NSLayoutAttributeTrailing
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:tabView
                                      attribute:NSLayoutAttributeTrailing
                                     multiplier:1
                                       constant:0]];
    }
    
    [tabView layoutSubtreeIfNeeded];
}


- (NSButton *)tabWithTitle:(NSString *)title
                     image:(NSImage *)image
                    isLast:(BOOL)isLast
{
    TKOJumpbarCell * cell = [[TKOJumpbarCell alloc] initTextCell:title];
    
    cell.title = title;
    cell.icon = image;
    cell.target = self;
    cell.action = @selector(selectTab:);
    [cell sendActionOn:NSLeftMouseDownMask];
    [cell setHighlightsBy:0];
    cell.imagePosition   = NSNoImage;
    cell.borderMask      = TKOBorderMaskBottom;
    cell.font            = [NSFont fontWithName:@"LucidaGrande"
                                           size:11];
    cell.isLast = isLast;
    NSButton * tab = [NSView viewWithClass:[NSButton class]];
    [tab setCell:cell];
    
    NSSize size = [tab intrinsicContentSize];
    CGFloat width = size.width + 40;
    
    [tab setContentHuggingPriority:NSLayoutPriorityDefaultHigh
                    forOrientation:NSLayoutConstraintOrientationHorizontal];
    [tab addConstraints:
     @[[NSLayoutConstraint constraintWithItem:tab
                                    attribute:NSLayoutAttributeWidth
                                    relatedBy:NSLayoutRelationEqual
                                       toItem:nil
                                    attribute:NSLayoutAttributeNotAnAttribute
                                   multiplier:1.0
                                     constant:width],
       
       [NSLayoutConstraint constraintWithItem:tab
                                    attribute:NSLayoutAttributeHeight
                                    relatedBy:NSLayoutRelationEqual
                                       toItem:nil
                                    attribute:NSLayoutAttributeNotAnAttribute
                                   multiplier:1.0
                                     constant:self.bounds.size.height],
       ]];
    
    return tab;
}


- (void)selectTab:(id)sender
{
    NSButton * selectedButton = sender;
    
    for (NSButton * button in [self.scrollView.documentView subviews])
    {
        if ([button isKindOfClass:[NSButton class]])
        {
            id item = [selectedButton.cell representedObject];
            [self setSelectedItem:item];
        }
    }
    
    [[NSApplication sharedApplication] sendAction:self.action
                                               to:self.target
                                             from:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TKOJumpbarDidChangeSelectionNotification
                                                        object:self];
}

- (void)resetItemsWithSelectedItem:(id)nomad
{
    NSMutableArray * items = [NSMutableArray new];
    while (nomad)
    {
        [items addObject:nomad];
        if ([nomad respondsToSelector:@selector(parent)])
            nomad = [nomad parent];
        else
            nomad = nil;
    }
    [self setItems:[NSArray arrayWithArray:[[items reverseObjectEnumerator] allObjects]]];
    [[NSNotificationCenter defaultCenter] postNotificationName:TKOJumpbarDidChangeSelectionNotification
                                                        object:self];
}

- (id)selectedItem
{
    return _selectedItem;
}

- (void)setSelectedItem:(id)selectedItem
{
    if (_selectedItem == selectedItem)
        return;

    if (_selectedItem)
    {
        [self.backwardHistory addObject:_selectedItem];
        [self.forwardHistory removeAllObjects];
        [self updateButtons];
    }
    
    _selectedItem = selectedItem;

    [self resetItemsWithSelectedItem:selectedItem];
    [self layoutTabViewWithItems];
}

- (void)goBackAction:(id)sender
{
    [self.forwardHistory addObject:_selectedItem];
    _selectedItem = self.backwardHistory.lastObject;
    [self resetItemsWithSelectedItem:_selectedItem];
    [self layoutTabViewWithItems];
    [self.backwardHistory removeLastObject];
    [sender setState:0];
    [self updateButtons];
}


- (void)goForwardAction:(id)sender
{
    [self.backwardHistory addObject:_selectedItem];
    _selectedItem = self.forwardHistory.lastObject;
    [self resetItemsWithSelectedItem:_selectedItem];
    [self layoutTabViewWithItems];
    [self.forwardHistory removeLastObject];
    [sender setState:0];
    [self updateButtons];
}

- (void)updateButtons
{
    [_goBackButton setEnabled:(self.backwardHistory.count > 0)];
    [_goForwardButton setEnabled:(self.forwardHistory.count > 0)];
}

#pragma mark - Drawing

+ (Class)cellClass
{
    return [TKOHeaderCell class];
}

- (BOOL)isOpaque {
    return YES;
}

- (BOOL)isFlipped {
    return YES;
}

@end

NSString * TKOJumpbarDidChangeSelectionNotification = @"TKOJumpbarDidChangeSelectionNotification";


