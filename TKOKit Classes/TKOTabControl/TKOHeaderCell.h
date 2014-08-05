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

@interface TKOHeaderCell : TKOButtonCell

@property(nonatomic) BOOL showsMenu;
@property(readonly, nonatomic) BOOL isShowingMenu;

//@property (nonatomic, copy) NSColor * textColor;
//@property (nonatomic, copy) NSColor * textHighlightColor;
//@property (nonatomic, copy) NSColor * imageColor;
//@property (nonatomic, copy) NSColor * imageHighlightColor;

+ (NSImage *)popupImage;
- (NSRect)popupRectWithFrame:(NSRect)cellFrame;

@end