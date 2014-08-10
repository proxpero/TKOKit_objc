//
//  TKOButton.h
//  TKOSegmentedControlDemo
//
//  Created by Todd Olsen on 6/28/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TKOButtonCell.h"

@interface TKOButton : NSButton

//@property (nonatomic) NSInteger state;
//@property (nonatomic) NSString * title;
//@property (nonatomic, weak) id target;
//@property (nonatomic) SEL action;

@property (nonatomic) TKOBorderMask borderMask;
@property (nonatomic) TKOBorderMask borderHighlightMask;
@property (nonatomic, copy) NSColor * backgroundColor;
@property (nonatomic, copy) NSColor * backgroundHighlightColor;
@property (nonatomic, copy) NSColor * borderColor;
@property (nonatomic, copy) NSColor * borderHighlightColor;
@property (nonatomic, copy) NSColor * textColor;
@property (nonatomic, copy) NSColor * textHighlightColor;
@property (nonatomic, copy) NSColor * imageColor;                 // defaults to textColor
@property (nonatomic, copy) NSColor * highlightImageColor;        // defaults to whiteColor

@property (nonatomic) NSGradient * backgroundGradient;
@property (nonatomic) NSGradient * backgroundHighlightGradient;

@end

//extern BOOL TKORectArrayWithBorderMask(NSRect sourceRect, TKOBorderMask borderMask, NSRect **rectArray, NSInteger *rectCount);

