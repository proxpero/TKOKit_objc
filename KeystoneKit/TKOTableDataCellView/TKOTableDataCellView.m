//
//  TKOTableDataCellView.m
//  Keystone-Mac
//
//  Created by Todd Olsen on 12/3/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOTableDataCellView.h"

@implementation TKOTableDataCellView

- (void)setBackgroundStyle:(NSBackgroundStyle)backgroundStyle
{
    [super setBackgroundStyle:backgroundStyle];
    
    NSFontTraitMask mask;
    NSColor * color;
    NSMutableAttributedString * title = self.textField.attributedStringValue.mutableCopy;
    NSRange range = NSMakeRange(0, title.length);
    
    if (backgroundStyle == NSBackgroundStyleDark) {
        mask = NSBoldFontMask;
        color = [NSColor labelColor];
    }
    
    else {
        mask = NSUnboldFontMask;
        color = [NSColor secondaryLabelColor];
    }
    
    [title applyFontTraits:mask range:range];
    [title addAttribute:NSForegroundColorAttributeName value:color range:range];
    self.textField.attributedStringValue = title;

}

@end
