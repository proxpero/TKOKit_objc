//
//  TKOTabView.m
//  TKOTabViewDemo
//
//  Created by Todd Olsen on 6/19/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOTabView.h"

@interface TKOTabView ()

@property (nonatomic) NSView * header;
@property (nonatomic) NSView * content;

@end

@implementation TKOTabView

- (instancetype)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (!self) return nil;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self configureSubviews];
    
    return self;
}

- (void)awakeFromNib
{
    [self configureSubviews];
}

- (void)configureSubviews
{
    static BOOL configured = NO; if (configured) return; configured = YES;
    
    self.wantsLayer = YES;
    self.layer.backgroundColor = [[NSColor darkGrayColor] CGColor];
    
    _header = [[NSView alloc] initWithFrame:NSZeroRect];
    _header.translatesAutoresizingMaskIntoConstraints = NO;
    
    _content = [[NSView alloc] initWithFrame:NSZeroRect];
    _content.translatesAutoresizingMaskIntoConstraints = NO;
    _content.wantsLayer = YES;
    _content.layer.backgroundColor = [[NSColor controlColor] CGColor];
    
    [self setSubviews:@[_header, _content]];
    
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_header(28)]-1-[_content]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(_header, _content)]
     ];
    
    for (NSView * view in self.subviews) {
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                 options:0
                                                 metrics:nil
                                                   views:NSDictionaryOfVariableBindings(view)]
         ];
    }
}

- (void)setTabViewItems:(NSArray *)tabViewItems
{
    _tabViewItems = tabViewItems;
    [self layoutItems];
}

- (void)setDelegate:(id<TKOTabViewDelegate>)delegate
{
    if (_delegate == delegate) return;
    
    _delegate = delegate;
    if (!_delegate) return;
    
    delegateRespondsTo.didChangeNumberOfTabViewItems = [_delegate respondsToSelector:@selector(tabViewDidChangeNumberOfTabViewItems:)];
    delegateRespondsTo.shouldSelectTabViewItem       = [_delegate respondsToSelector:@selector(tabView:shouldSelectTabViewItem:)];
    delegateRespondsTo.willSelectTabViewItem         = [_delegate respondsToSelector:@selector(tabView:willSelectTabViewItem:)];
    delegateRespondsTo.didChangeNumberOfTabViewItems = [_delegate respondsToSelector:@selector(tabView:didSelectTabViewItem:)];
}

- (void)setFont:(NSFont *)font
{
    if (_font == font) return;
    _font = font;
    if (self.tabViewItems.count > 0) [self layoutItems];
}

- (void)setButtonColor:(NSColor *)buttonColor
{
    if (_buttonColor == buttonColor) return;
    _buttonColor = buttonColor.copy;
    if (self.tabViewItems.count > 0) [self layoutItems];
}

- (void)setHighlightButtonColor:(NSColor *)highlightButtonColor
{
    if (_highlightButtonColor == highlightButtonColor) return;
    _highlightButtonColor = highlightButtonColor.copy;
    if (self.tabViewItems.count > 0) [self layoutItems];
}

- (void)setTextColor:(NSColor *)textColor
{
    if (_textColor == textColor) return;
    _textColor = textColor.copy;
    if (self.tabViewItems.count > 0) [self layoutItems];
}

- (void)setHighlightTextColor:(NSColor *)highlightTextColor
{
    if (_highlightTextColor == highlightTextColor.copy) return;
    _highlightTextColor = highlightTextColor;
    if (self.tabViewItems.count > 0) [self layoutItems];
}

- (void)setImageColor:(NSColor *)imageColor
{
    if (_imageColor == imageColor) return;
    _imageColor = imageColor.copy;
    if (self.tabViewItems.count > 0) [self layoutItems];
}

- (void)setHighlightImageColor:(NSColor *)highlightImageColor
{
    if (_highlightImageColor == highlightImageColor) return;
    _highlightImageColor = highlightImageColor.copy;
    if (self.tabViewItems.count > 0) [self layoutItems];
}

- (void)layoutItems
{
    [self.header removeConstraints:self.constraints];
    NSMutableArray * buttons = [NSMutableArray new];
    for (id <TKOTabViewItem> tvi in self.tabViewItems) {
        [buttons addObject:[self buttonForTabViewItem:tvi]];
    }
    
    [self.header setSubviews:buttons];
    
    NSButton * prev = nil;
    for (NSButton * button in buttons) {
        
        [self.header addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|"
                                                 options:0
                                                 metrics:nil
                                                   views:NSDictionaryOfVariableBindings(button)]
         ];
        
        [self.header addConstraint:
         [NSLayoutConstraint constraintWithItem:button
                                      attribute:NSLayoutAttributeLeading
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:prev != nil ? prev : self.header
                                      attribute:prev != nil ? NSLayoutAttributeTrailing : NSLayoutAttributeLeading
                                     multiplier:1
                                       constant:prev != nil ? 1 : 0]
         ];
        
        if (prev) {
            [self.header addConstraint:
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
        [self.header addConstraint:
         [NSLayoutConstraint constraintWithItem:prev
                                      attribute:NSLayoutAttributeTrailing
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.header
                                      attribute:NSLayoutAttributeTrailing
                                     multiplier:1
                                       constant:0]
         ];
    }
    
    NSButton * button = self.header.subviews.firstObject;
    [self selectTab:button];
    
}

- (NSButton *)buttonForTabViewItem:(id <TKOTabViewItem>)tvi
{
    NSButton * button = [[NSButton alloc] initWithFrame:NSZeroRect];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    
    button.target = self;
    button.action = @selector(selectTab:);
    
    button.buttonType = NSMomentaryLightButton;
    button.bordered = NO;
    
    button.title = tvi.title;
    [button.cell setRepresentedObject:tvi.view];
    button.font = self.font ?: [NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSRegularControlSize]];
    
    return button;
}

- (void)selectTab:(id)sender
{
    id <TKOTabViewItem> tvi = self.tabViewItems[ [self.header.subviews indexOfObject:sender] ];
    
    if (delegateRespondsTo.shouldSelectTabViewItem && ![self.delegate tabView:self shouldSelectTabViewItem:tvi]) return;
    if (delegateRespondsTo.willSelectTabViewItem) [self.delegate tabView:self willSelectTabViewItem:tvi];
    
    for (NSButton * button in self.header.subviews) {
        button.state = NSOffState;
        [button.cell setBackgroundColor:self.buttonColor ?: [NSColor controlColor]];
        NSMutableAttributedString * attrStr = button.attributedTitle.mutableCopy;
        [attrStr addAttribute:NSForegroundColorAttributeName value:self.textColor ?: [NSColor textColor] range:NSMakeRange(0, attrStr.length)];
        button.attributedTitle = attrStr;
    }
    
    NSButton * button = (NSButton *)sender;
    button.state = NSOnState;
    [button.cell setBackgroundColor:self.highlightButtonColor ?: [NSColor highlightColor]];
    NSMutableAttributedString * attrStr = button.attributedTitle.mutableCopy;
    [attrStr addAttribute:NSForegroundColorAttributeName value:self.highlightTextColor ?: [NSColor blueColor] range:NSMakeRange(0, attrStr.length)];
    button.attributedTitle = attrStr;

    NSView * view = [button.cell representedObject];
    [self.content setSubviews:@[ view ]];
    [self.content addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(view)]
     ];

    [self.content addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                             options:0
                                             metrics:nil
                                               views:NSDictionaryOfVariableBindings(view)]
     ];
    
    if (delegateRespondsTo.didChangeNumberOfTabViewItems) [self.delegate tabView:self didSelectTabViewItem:tvi];
}

@end

@implementation TKOTabViewItem

- (instancetype)initWithTitle:(NSString *)title view:(NSView *)view
{
    self = [super init];
    if (!self) return nil;
    
    _title = title;
    _view  = view;
    
    return self;
}

@end
