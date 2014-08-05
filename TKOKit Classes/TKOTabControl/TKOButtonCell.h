//
//  TKOButtonCell.h
//  Keystone
//
//  Created by Todd Olsen on 12/14/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSColor+TKOKit.h"
#import "NSImage+TKOKit.h"


typedef enum {
    TKOBorderMaskTop     = (1<<0),
    TKOBorderMaskLeft    = (1<<1),
    TKOBorderMaskRight   = (1<<2),
    TKOBorderMaskBottom  = (1<<3)
} TKOBorderMask;


@interface TKOButtonCell : NSButtonCell

@property (nonatomic) TKOBorderMask borderMask;
@property (nonatomic) TKOBorderMask borderHighlightMask;
@property (nonatomic, copy) NSColor * borderColor;
@property (nonatomic, copy) NSColor * borderHighlightColor;

@property (nonatomic, copy) NSColor * backgroundColor;
@property (nonatomic, copy) NSColor * backgroundHighlightColor;
@property (nonatomic, copy) NSColor * textColor;
@property (nonatomic, copy) NSColor * textHighlightColor;
@property (nonatomic, copy) NSColor * imageColor;
@property (nonatomic, copy) NSColor * imageHighlightColor;

@property (nonatomic) NSGradient * backgroundGradient;
@property (nonatomic) NSGradient * backgroundHighlightGradient;
@property (nonatomic) CGFloat gradientAngle;

@property (nonatomic) CGFloat verticalTextOffset;
@property (nonatomic) CGFloat verticalImageOffset;

@property (nonatomic) BOOL hasAdaptiveBorderColor;

- (void)drawBordersInCellFrame:(NSRect)cellFrame;

@end

extern BOOL TKORectArrayWithBorderMask(NSRect sourceRect, TKOBorderMask borderMask, NSRect **rectArray, NSInteger *rectCount);

extern NSString * const TKOSidebarItemLabelKey;
extern NSString * const TKOSidebarItemImageKey;
extern NSString * const TKOSidebarItemTagKey;
extern NSString * const TKOSidebarItemGravityKey;
