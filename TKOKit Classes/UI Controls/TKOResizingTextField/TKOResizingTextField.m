//
//  TKOResizingTextField.m
//  TKOResizingTextFieldDemo
//
//  Created by Todd Olsen on 7/10/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOResizingTextField.h"
#import "NSString+Geometrics.h"

@implementation TKOResizingTextField

- (void)awakeFromNib
{
    NSTextView * fieldEditor = (NSTextView *)[self.window fieldEditor:YES forObject:nil];
//    fieldEditor.font = [NSFont fontWithName:@"Baskerville" size:20];
    fieldEditor.textContainerInset = NSMakeSize(20, 20);
    self.stringValue = @"Text Goes here";
    [self resizeTextView];
}


- (void)textDidChange:(NSNotification *)notification
{
    [self resizeTextView];
}

- (void)resizeTextView
{
    CGFloat height = [self.stringValue heightForWidth:self.bounds.size.width - 40 font:self.font];
//    height += _doubleInset; // vertical padding
//    if (height < _minHeight) height = _minHeight;
    self.heightConstraint.constant = height + 40;
}

@end
