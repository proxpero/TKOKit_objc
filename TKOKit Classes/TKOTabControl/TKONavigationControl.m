//
//  TKONavigationControl.m
//  Keystone
//
//  Created by Todd Olsen on 12/13/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "TKONavigationControl.h"
#import "TKONavigationCell.h"
#import "NSView+TKOKit.h"
#import "TKOHeaderCell.h"

@interface TKONavigationControl ()

@property (strong, nonatomic) NSButton    * backButton;
@property (strong, nonatomic) NSButton    * configureButton;
@property (strong, nonatomic) NSTextField * titleLabel;

@property (strong, nonatomic) NSTrackingArea * trackingArea;

@end

@implementation TKONavigationControl

- (id)initWithFrame:(NSRect)frameRect
{
    if ( !(self = [super initWithFrame:frameRect]) ) return nil;
    [self configureSubviews];
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configureSubviews];
}

- (void)configureSubviews
{
    if (!_backButton) {
        _trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds
                                                     options:NSTrackingMouseEnteredAndExited|NSTrackingActiveAlways
                                                       owner:self
                                                    userInfo:nil];
        [self addTrackingArea:_trackingArea];
        
        [self.cell setTitle:@"Navigation"];
        [self.cell setBorderMask:TKOBorderMaskBottom];
        [self.cell setFont:[NSFont fontWithName:@"HelveticaNeue-Medium"
                                           size:13]];
        [self.cell setImagePosition:NSNoImage];

        _backButton = [self buttonWithImage:[NSImage imageNamed:NSImageNameGoLeftTemplate]];
        [_backButton setTarget:self];
        [_backButton setAction:@selector(backButtonAction:)];
        [_backButton.cell sendActionOn:NSLeftMouseDownMask];
        [_backButton.cell setHighlightsBy:NSNoCellMask];
        
        _configureButton = [self buttonWithImage:[NSImage imageNamed:NSImageNameActionTemplate]];
        
        [self setSubviews:@[_backButton, _configureButton]];
        NSDictionary * views = NSDictionaryOfVariableBindings(_backButton, _configureButton);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backButton]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_configureButton]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];
        for (NSView * view in views.allValues) {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:@{@"view":view}]];
        }
    }
}

- (NSButton *)buttonWithImage:(NSImage *)image
{
    NSButton * button = [NSView viewWithClass:[NSButton class]];
    TKOHeaderCell * cell = [[TKOHeaderCell alloc] initImageCell:image];
    [cell setBorderMask:TKOBorderMaskBottom];
    [button setCell:cell];
    [button addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:nil
                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                      multiplier:1
                                                        constant:self.bounds.size.height]];
    return button;
}

- (void)setDelegate:(id<TKONavigationControlDelegate>)delegate
{
    if (_delegate == delegate) return;
    
    if (_delegate && [_delegate respondsToSelector:@selector(navigationControlDidClickBackButton:)])
        [[NSNotificationCenter defaultCenter] removeObserver:_delegate
                                                        name:TKONavigationControlDidClickBackButtonNotification
                                                      object:self];
    
    _delegate = delegate;
    
    if (_delegate && [_delegate respondsToSelector:@selector(navigationControlDidClickBackButton:)])
        [[NSNotificationCenter defaultCenter] addObserver:_delegate
                                                 selector:@selector(navigationControlDidClickBackButton:)
                                                     name:TKONavigationControlDidClickBackButtonNotification
                                                   object:self];
    [self reloadData];
}

- (void)reloadData
{
    [self.cell setTitle:[_delegate titleForNavigationControl:self]];
}

- (void)backButtonAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TKONavigationControlDidClickBackButtonNotification
                                                        object:self];
    [sender setState:NSOffState];
}

+ (Class)cellClass {
    return [TKOHeaderCell class];
}

- (void)dealloc {
    [self removeTrackingArea:self.trackingArea];
}

- (void)setBorderColor:(NSColor *)borderColor {
    [self.cell setBorderColor:borderColor];
}

- (void)setBackgroundColor:(NSColor *)backgroundColor {
    [self.cell setBackgroundColor:backgroundColor];
}

- (void)mouseEntered:(NSEvent *)theEvent {
    [self.backButton setHidden:NO];
    [self.configureButton setHidden:NO];
    BOOL enabled = _delegate ? [_delegate navigationControlShouldEnableBackButton:self] : NO;
    [self.backButton setEnabled:enabled];
}
- (void)mouseExited:(NSEvent *)theEvent {
    [self.backButton setHidden:YES];
    [self.configureButton setHidden:YES];
}

- (BOOL)isOpaque { return YES; }
- (BOOL)isFlipped { return YES; }

@end

NSString * TKONavigationControlDidClickBackButtonNotification = @"TKONavigationControlDidClickBackButtonNotification";
