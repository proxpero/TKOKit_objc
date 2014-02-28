//
//  TKOFlexibleToolbarItem.m
//  Keystone
//
//  Created by Todd Olsen on 1/1/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOFlexibleToolbarItem.h"
#import "NSView+TKOKit.h"

#define MAGIC_CONSTANT_1 16
#define MAGIC_CONSTANT_2 -8 // unused

@implementation TKOFlexibleToolbarItem

- (id)initWithItemIdentifier:(NSString *)itemIdentifier
{
    self = [super initWithItemIdentifier:itemIdentifier];
    if (!self)
        return self;
    
    [self configureView];
    
    return self;
}

- (void)awakeFromNib
{
    if (!self.view)
        [self configureView];
}

- (void)configureView
{
    self.view = [NSView viewWithClass:[NSView class]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1
                                                           constant:28]];
}

- (void)setAuxilliaryView:(NSView *)auxilliaryView
{
    if (_auxilliaryView == auxilliaryView)
        return;
    
    if (_auxilliaryView)    // Unnecessary?
        [_auxilliaryView removeFromSuperview];
    
    _auxilliaryView = auxilliaryView;
    
    [self.view addSubview:_auxilliaryView];
    NSDictionary * views = NSDictionaryOfVariableBindings(_auxilliaryView);
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_auxilliaryView]|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    [self.view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_auxilliaryView]-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
}

//- (void)setPopupButton:(NSPopUpButton *)popupButton
//{
//    if (_popupButton == popupButton)
//        return;
//    
//    if (_popupButton)
//        [_popupButton removeFromSuperview];
//    
//    _popupButton = popupButton;
//    
//    [self.view addSubview:_popupButton];
////    [self.view addFullSizeConstraintsForSubview:_popupButton];
//    NSDictionary * views = NSDictionaryOfVariableBindings(_popupButton);
//    [self.view addConstraints:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_popupButton]|"
//                                             options:0
//                                             metrics:nil
//                                               views:views]];
//    [self.view addConstraints:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_popupButton]-|"
//                                             options:0
//                                             metrics:nil
//                                               views:views]];
//
//}

-(NSString *)label
{
    return @"";
}

-(NSString *)paletteLabel
{
    return @"Main Navigation Item";
}

-(NSSize)minSize
{
    if (self.linkedView) {
        CGFloat width = NSWidth(self.linkedView.bounds);
        CGFloat height = NSHeight(self.view.bounds);
        NSSize size;
        if (width - MAGIC_CONSTANT_1 > MAGIC_CONSTANT_2)
            size = NSMakeSize(width - MAGIC_CONSTANT_1, height);
        else
            size = NSMakeSize(MAGIC_CONSTANT_2, height);
        return size;
    }
    
    return [super minSize];
}

-(NSSize)maxSize
{
    if (self.linkedView) {
        CGFloat width = NSWidth(self.linkedView.bounds);
        CGFloat height = NSHeight(self.view.bounds);
        
        NSSize size;
        if (width - MAGIC_CONSTANT_1 > MAGIC_CONSTANT_2)
            size = NSMakeSize(width - MAGIC_CONSTANT_1, height);
        else
            size = NSMakeSize(MAGIC_CONSTANT_2, height);
    }
    
    return [super maxSize];
}

- (void)updateWidth
{
    if (self.linkedView) {
        CGFloat width = NSWidth(self.linkedView.bounds);
        CGFloat height = NSHeight(self.view.bounds);
        
        NSSize size;
        if (width - MAGIC_CONSTANT_1 > MAGIC_CONSTANT_2)
            size = NSMakeSize(width - MAGIC_CONSTANT_1, height);
        else
            size = NSMakeSize(MAGIC_CONSTANT_2, height);
    
        [self setMinSize:size];
        [self setMaxSize:size];
    }
}

- (BOOL)allowsDuplicatesInToolbar
{
    return YES;
}


@end
