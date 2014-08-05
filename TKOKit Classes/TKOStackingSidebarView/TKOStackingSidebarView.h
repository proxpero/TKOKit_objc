//
//  TKOStackingSidebarView.h
//  TKOStackingSidebarDemo
//
//  Created by Todd Olsen on 7/4/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TKOButtonCell.h"

@interface TKOStackingSidebarView : NSStackView

@property (nonatomic, weak) id target;
@property (nonatomic) SEL action;

@property (nonatomic) NSInteger selectedTag;
@property (nonatomic) NSInteger selectedIndex; // NSNotFound
@property (nonatomic) NSString * selectedIdentifier;

@property (nonatomic) NSGradient * gradient;
@property (nonatomic) CGFloat buttonHeight;

@property (nonatomic) NSFont * font;
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

- (void)setItems:(NSArray *)items;

@end




