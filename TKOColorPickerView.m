//
//  TKOColorPickerView.m
//  TKOKit
//
//  Created by Todd Olsen on 1/30/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOColorPickerView.h"
#import "NSView+TKOKit.h"

@interface TKOColorPickerView()

@property (strong, nonatomic) NSButton * paletteButton;
@property (strong, nonatomic) NSButton * colorPanelButton;
@property (strong, nonatomic) NSPopover * palettePopover;
@property (strong, nonatomic) TKOPaletteViewController * paletteViewController;

@end

@implementation TKOColorPickerView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;

    [self setWantsLayer:YES];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[NSColor darkGrayColor] CGColor];
    self.layer.cornerRadius = 4;
    
    _selectedColor = [NSColor lightGrayColor];
    [self configureSubviews];
    
    return self;
}

- (void)awakeFromNib
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:66]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:21]];
}

- (void)configureSubviews
{
    if (_paletteButton && _colorPanelButton)
        return;
    
    _paletteButton = [NSView viewWithClass:[NSButton class]];
    [_paletteButton setTitle:@""];
    [_paletteButton setBordered:NO];
    [_paletteButton.cell setHighlightsBy:NSNoCellMask];
    [_paletteButton setWantsLayer:YES];
    _paletteButton.layer.backgroundColor = [self.selectedColor CGColor];
    [_paletteButton setTarget:self];
    [_paletteButton setAction:@selector(showPopover:)];
    [_paletteButton addConstraint:
     [NSLayoutConstraint constraintWithItem:_paletteButton
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:46]];
    
    _colorPanelButton = [NSView viewWithClass:[NSButton class]];
    [_colorPanelButton setBordered:NO];
    [_colorPanelButton setImage:[NSImage imageNamed:@"color1"]];
    
    [self setSubviews:@[_paletteButton, _colorPanelButton]];
    NSDictionary * views = NSDictionaryOfVariableBindings(_paletteButton, _colorPanelButton);
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_paletteButton(==46)][_colorPanelButton]|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    for (NSView * view in views.allValues) {
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                 options:0
                                                 metrics:nil
                                                   views:@{@"view": view}]];
    }    
}

- (void)showPopover:(id)sender
{
    if (!_palettePopover) {
        _palettePopover = [[NSPopover alloc] init];
        _paletteViewController = [[TKOPaletteViewController alloc] init];
        [_palettePopover setContentViewController:_paletteViewController];
    }
    [self.palettePopover showRelativeToRect:self.paletteButton.bounds
                                     ofView:sender
                              preferredEdge:NSMaxYEdge];
}

@end

@interface TKOPaletteViewController ()

@end

@implementation TKOPaletteViewController

- (id)init
{
    self = [[TKOPaletteViewController alloc] initWithNibName:@"TKOPaletteViewController"
                                                      bundle:nil];
    if (!self)
        return nil;
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return self;
}

@end

