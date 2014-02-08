//
//  TKOControlCell.h
//  TKOKit
//
//  Created by Todd Olsen on 1/29/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSImage+TKOKit.h"
#import "NSColor+TKOKit.h"

typedef enum {
    TKOBorderMaskTop     = (1<<0),
    TKOBorderMaskLeft    = (1<<1),
    TKOBorderMaskRight   = (1<<2),
    TKOBorderMaskBottom  = (1<<3)
} TKOBorderMask;

@interface TKOControlCell : NSButtonCell

@property (nonatomic) TKOBorderMask   borderMask;
@property (nonatomic, copy) NSColor * backgroundColor;
@property (nonatomic, copy) NSColor * backgroundHighlightColor;
@property (nonatomic, copy) NSColor * borderColor;
@property (nonatomic, copy) NSColor * borderHighlightColor;
@property (nonatomic) BOOL hasAdaptiveBorderColor;

@end

extern BOOL TKORectArrayWithBorderMask(NSRect sourceRect, TKOBorderMask borderMask, NSRect **rectArray, NSInteger *rectCount);
