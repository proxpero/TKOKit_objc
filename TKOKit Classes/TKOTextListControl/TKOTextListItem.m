//
//  TKOTextListItem.m
//  TKOTextItemViewDemo
//
//  Created by Todd Olsen on 6/4/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOTextListItem.h"
#import "NSView+TKOKit.h"
#import "NSString+Geometrics.h"
#import "TKOItemTextView.h"

#define TEXT_INSET 7.0
#define SINGLE_LINE_HEIGHT 23.0

@interface TKOTextListItem ()
@property (nonatomic, strong) NSLayoutConstraint * heightConstraint;
@end

@implementation TKOTextListItem

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    NSFont * font = [NSFont fontWithName:@"Baskerville" size:20.0];
    
    _label = [NSView viewWithClass:[NSTextField class]];
    _label.editable = NO;
    _label.selectable = NO;
    _label.font = font;
    _label.alignment = NSRightTextAlignment;
    _label.bordered = NO;
    _label.textColor = [NSColor darkGrayColor];
    
    [_label addConstraintsForWidth:40 height:SINGLE_LINE_HEIGHT + TEXT_INSET + TEXT_INSET];
    
//    _textView = [NSView viewWithClass:[TKOItemTextView class]];
//    _textView.textContainerInset = NSMakeSize(TEXT_INSET, TEXT_INSET);
//    _textView.font = font;
//    _textView.delegate = self;
    
    [self setSubviews:@[_label, _textView]];
    
    _heightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:SINGLE_LINE_HEIGHT + TEXT_INSET + TEXT_INSET];
    [self addConstraint:_heightConstraint];

    NSDictionary * views = @{@"textView": _textView, @"label": _label};
    
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label][textView]|"
                                             options:0
                                             metrics:nil
                                               views:views]
     ];
    
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textView]|"
                                             options:0
                                             metrics:nil
                                               views:views]
     ];
    
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:_label
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:_textView
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1
                                   constant:1]
     ];

    return self;
}

- (BOOL)becomeFirstResponder
{
    return NO;
}

//- (void)setFrameSize:(NSSize)newSize
//{
//    [super setFrameSize:newSize];
//    [self resizeText];
//}

//- (void)textDidChange:(NSNotification *)notification
//{
//    [self resizeText];
//}

//- (void)resizeText
//{
//    CGFloat height = [self.textView.attributedString heightForWidth:self.textView.bounds.size.width - (TEXT_INSET + TEXT_INSET)];
//    if (height < SINGLE_LINE_HEIGHT) height = SINGLE_LINE_HEIGHT;
//    height = height + TEXT_INSET + TEXT_INSET;
//    self.heightConstraint.constant = height;
//}

- (void)setDelegate:(id<TKOListItemDelegate>)delegate
{
    if (_delegate == delegate) return;
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    
    if (_delegate && [_delegate respondsToSelector:@selector(textListItemWantsNewSibling:)])
    {
        [center removeObserver:_delegate
                          name:TKOTextListItemWantsNewSiblingNotification
                        object:self];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(textListItemWantsAdvancement:)])
    {
        [center removeObserver:_delegate
                          name:TKOTextListItemWantsAdvancementNotification
                        object:self];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(textListItemWantsPrevious:)])
    {
        [center removeObserver:_delegate
                          name:TKOTextListItemWantsPreviousNotification
                        object:self];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(deleteTextListItem:)])
    {
        [center removeObserver:_delegate
                          name:TKODeleteTextListItemNotification
                        object:self];
    }
    
    _delegate = delegate;
    
    if (_delegate && [_delegate respondsToSelector:@selector(textListItemWantsNewSibling:)])
    {
        [center addObserver:_delegate
                   selector:@selector(textListItemWantsNewSibling:)
                       name:TKOTextListItemWantsNewSiblingNotification
                     object:self];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(textListItemWantsAdvancement:)])
    {
        [center addObserver:_delegate
                   selector:@selector(textListItemWantsAdvancement:)
                       name:TKOTextListItemWantsAdvancementNotification
                     object:self];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(textListItemWantsPrevious:)])
    {
        [center addObserver:_delegate
                   selector:@selector(textListItemWantsPrevious:)
                       name:TKOTextListItemWantsPreviousNotification
                     object:self];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(deleteTextListItem:)])
    {
        [center addObserver:_delegate
                   selector:@selector(deleteTextListItem:)
                       name:TKODeleteTextListItemNotification
                     object:self];
    }
}

@end

NSString * TKOTextListItemWantsNewSiblingNotification = @"TKOTextListItemWantsNewSiblingNotification";
NSString * TKOTextListItemWantsAdvancementNotification = @"TKOTextListItemWantsAdvancementNotification";
NSString * TKOTextListItemWantsPreviousNotification = @"TKOTextListItemWantsPreviousNotification";
NSString * TKODeleteTextListItemNotification = @"TKODeleteTextListItemNotification";