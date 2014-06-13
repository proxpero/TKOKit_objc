//
//  TKOListItemView.m
//  ProblemEditor
//
//  Created by Todd Olsen on 6/9/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOListItemView.h"
#import "TKOProblemEditorTextView.h"
#import "NSView+TKOKit.h"

@interface TKOListItemView ()

@end

@implementation TKOListItemView

+ (instancetype)itemWithPlaceholder:(NSString *)placeholder
                               font:(NSFont *)font
                         itemIndent:(CGFloat)itemIndent
{
    TKOListItemView * item = [[self alloc] initWithFrame:NSZeroRect];
    if (!item) return nil;
    item.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSTextField * label = [[NSTextField alloc] initWithFrame:NSZeroRect];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    label.editable      = NO;
    label.selectable    = NO;
    label.font          = font;
    label.alignment     = NSRightTextAlignment;
    label.bordered      = NO;
    label.textColor     = [NSColor darkGrayColor];
    item.label          = label;
    
    item.textView       = [[TKOProblemEditorTextView alloc] initWithPlaceholder:placeholder];
    
    CGFloat singleLineHeight = ceilf(font.ascender + fabsf(font.descender));
    NSSize inset             = item.textView.textContainerInset;
    
    [item.label addConstraintsForWidth:itemIndent
                                height:(singleLineHeight + inset.height + inset.height)];
    
    [item setSubviews:@[item.label, item.textView]];
    NSDictionary * views = @{@"textView": item.textView, @"label": item.label};
    [item addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[label][textView]-13-|"
                                             options:0
                                             metrics:nil
                                               views:views]
     ];
    
    [item addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textView]|"
                                             options:0
                                             metrics:nil
                                               views:views]
     ];
    
    [item addConstraint:
     [NSLayoutConstraint constraintWithItem:item.label
                                  attribute:NSLayoutAttributeTop
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:item.textView
                                  attribute:NSLayoutAttributeTop
                                 multiplier:1
                                   constant:1]
     ];
    
    return item;
}

@end