//
//  TKONewSidebarView.h
//  TKOSidebarDemo
//
//  Created by Todd Olsen on 6/26/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TKOThemeLoader.h"
#import "TKOTheme.h"

@interface TKONewSidebarView : NSView

//@property (nonatomic, copy) NSColor * backgroundColor;
//@property (nonatomic, copy) NSColor * backgroundHighlightColor;
//@property (nonatomic, copy) NSColor * imageColor;
//@property (nonatomic, copy) NSColor * imageHighlightColor;
//@property (nonatomic, copy) NSColor * textColor;
//@property (nonatomic, copy) NSColor * textHighlightColor;
//@property (nonatomic, copy) NSColor * borderColor;
//@property (nonatomic, copy) NSColor * borderHighlightColor;
//@property (nonatomic)       NSFont * font;

@property (nonatomic) id target;
@property (nonatomic) SEL action;

@end
