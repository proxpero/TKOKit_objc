//
//  TKOSidebar.m
//  TKOSidebarDemo
//
//  Created by Todd Olsen on 4/7/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOSidebar.h"
#import "TKOSidebarCell.h"
#import "TKOControl.h"
#import "NSColor+TKOKit.h"

@interface TKOSidebar ()

@property (nonatomic, readwrite) NSMutableArray * items;

@end

@implementation TKOSidebar

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.orientation = NSUserInterfaceLayoutOrientationVertical;
    self.alignment = NSLayoutAttributeCenterX;
    self.spacing = 0.0;
    
    self.wantsLayer = YES;
    self.layer.backgroundColor = [[NSColor lightGrayColor] CGColor];
    self.items = [NSMutableArray new];
    
    return self;
}

- (void)addItemWithImage:(NSImage *)image
                   title:(NSString *)title
       representedObject:(id)representedObject
               inGravity:(NSStackViewGravity)gravity
{
    NSButton * button = [[NSButton alloc] initWithFrame:NSZeroRect];
    
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.bordered = NO;
    button.wantsLayer = YES;
    
    TKOSidebarCell * cell = [[TKOSidebarCell alloc] init];
    
    cell.backgroundColor = [NSColor lightGrayColor];
    cell.backgroundHighlightColor = [NSColor controlColor];
    cell.imageColor = [NSColor darkGrayColor];
    cell.imageHighlightColor = [NSColor colorWithHexString:@"AC1326"];
    cell.textColor      = [NSColor darkGrayColor];
    cell.textHighlightColor = [NSColor darkGrayColor];
    cell.borderColor = [NSColor colorWithHexString:@"C2BFC3"];
    cell.borderHighlightColor = [NSColor colorWithHexString:@"AC1326"];
    cell.borderMask = (gravity == NSStackViewGravityTop) ? TKOBorderMaskBottom : TKOBorderMaskTop;
    cell.borderHighlightMask = TKOBorderMaskTop|TKOBorderMaskBottom;
    cell.showsStateBy   = NSChangeBackgroundCellMask;
    cell.highlightsBy   = 0;
    cell.image          = image;
    cell.buttonType     = NSOnOffButton;
    cell.target         = self;
    cell.action         = @selector(selectTabAction:);
    cell.title          = title;
    cell.font           = [NSFont fontWithName:@"HelveticaNeue-Light" size:11];
    cell.imagePosition  = NSImageAbove;
    cell.representedObject = representedObject;
    button.cell = cell;

    [self addView:button inGravity:gravity];

    [button addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:62]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button]|" options:0 metrics:nil views:@{@"button": button}]];
}

- (void)selectTabAction:(id)sender
{
    id representedObject = [[sender cell] representedObject];
    for (NSButton * button in self.views)
        button.state = (button == sender) ? 1 : 0;    
    [representedObject sendAction:self.action to:self.target];
}

@end
