//
//  TKOHeaderCell.h
//  Keystone
//
//  Created by Todd Olsen on 12/2/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TKOButtonCell.h"
#import "NSImage+TKOKit.h"
#import "NSColor+TKOKit.h"

//typedef enum {
//    TKOBorderMaskTop     = (1<<0),
//    TKOBorderMaskLeft    = (1<<1),
//    TKOBorderMaskRight   = (1<<2),
//    TKOBorderMaskBottom  = (1<<3)
//} TKOBorderMask;

@interface TKOHeaderCell : TKOButtonCell

@property(nonatomic) BOOL showsMenu;
@property(readonly, nonatomic) BOOL isShowingMenu;

////@property (nonatomic) TKOBorderMask   borderMask;
//@property (nonatomic, copy) NSColor * backgroundColor;
//@property (nonatomic, copy) NSColor * backgroundHighlightColor;
////@property (nonatomic, copy) NSColor * borderColor;
//@property (nonatomic, copy) NSColor * borderHighlightColor;
@property (nonatomic, copy) NSColor * textColor;
@property (nonatomic, copy) NSColor * textHighlightColor;
@property (nonatomic, copy) NSColor * imageColor;
@property (nonatomic, copy) NSColor * imageHighlightColor;

+ (NSImage *)popupImage;
- (NSRect)popupRectWithFrame:(NSRect)cellFrame;
- (void)drawBordersInCellFrame:(NSRect)cellFrame;

@end

//extern BOOL TKORectArrayWithBorderMask(NSRect sourceRect, TKOBorderMask borderMask, NSRect **rectArray, NSInteger *rectCount);

