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
    self.spacing = 1.0;
    
    self.wantsLayer = YES;
    self.layer.backgroundColor = [[NSColor lightGrayColor] CGColor];
    self.items = [NSMutableArray new];
    
    return self;
}

- (void)addItemWithImage:(NSImage *)image
          alternateImage:(NSImage *)alternateImage
                   title:(NSString *)title
               inGravity:(NSStackViewGravity)gravity
{
    NSButton * button = [[NSButton alloc] initWithFrame:NSZeroRect];
    
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.bordered = NO;
    button.wantsLayer = YES;
    
    TKOSidebarCell * cell = [[TKOSidebarCell alloc] init];
    
    cell.backgroundColor = [NSColor lightGrayColor];
    cell.backgroundHighlightColor = [NSColor controlColor];
    cell.textColor      = [NSColor darkGrayColor];
    cell.textHighlightColor = [NSColor darkGrayColor];
    cell.showsStateBy   = NSChangeBackgroundCellMask;
    cell.highlightsBy   = NSChangeBackgroundCellMask;
    cell.image          = image;
    cell.alternateImage = alternateImage;
    cell.buttonType     = NSOnOffButton;
    cell.target         = self;
    cell.action         = @selector(selectTabAction:);
    cell.title          = title;
    cell.font           = [NSFont fontWithName:@"Helvetica" size:10];
    cell.imagePosition  = NSImageAbove;
    
    button.cell = cell;

    [self addView:button inGravity:gravity];

    [button addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:62]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button]|" options:0 metrics:nil views:@{@"button": button}]];
}

//- (TKOControl *)newTab
//{
//    TKOControl * button = [[TKOControl alloc] initWithFrame:NSZeroRect];
//    button.translatesAutoresizingMaskIntoConstraints = NO;
//    button.wantsLayer = YES;
//    button.layer.backgroundColor = [[NSColor lightGrayColor] CGColor];
//    button.target = self;
//    button.action = @selector(selectTabAction:);
//
//    [button addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:62]];
//    [button addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:62]];
//    TKOSidebarCell * cell = [[TKOSidebarCell alloc] init];
//    cell.showsStateBy = NSChangeBackgroundCellMask;
//    cell.highlightsBy = NSChangeBackgroundCellMask;
//    button.cell = cell;
//    
//    return button;
//}

- (void)selectTabAction:(id)sender
{
    for (NSButton * button in self.views)
        if (button == sender)
            button.state = 1;
        else
            button.state = 0;

    [sender sendAction:self.action to:self.target];
}

@end
