//
//  TKOSidebarView.m
//  TKOSidebarDemo
//
//  Created by Todd Olsen on 4/11/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOSidebarView.h"
#import "TKOSidebarViewItem.h"
#import "TKOSidebarCell.h"

#import "NSView+TKOKit.h"
#import "NSColor+TKOKit.h"

@interface TKOSidebarView ()

@property (nonatomic) NSStackView * sidebar;
@property (nonatomic) NSMutableArray * sidebarViewItems;
@property (nonatomic) NSView * contentView;
@property (nonatomic) NSUInteger selectedIndex;

@end

@implementation TKOSidebarView

- (id)initWithFrame:(NSRect)frame sidebarType:(TKOSidebarType)sidebarType
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self setupSidebar];
    
    _sidebarViewItems = [NSMutableArray new];
    
    _backgroundColor = [NSColor lightGrayColor];
    _backgroundHighlightColor = [NSColor controlColor];
    _imageColor = [NSColor darkGrayColor];
    _imageHighlightColor = [NSColor colorWithHexString:@"AC1326"];
    _textColor      = [NSColor darkGrayColor];
    _textHighlightColor = [NSColor darkGrayColor];
    _borderColor = [NSColor colorWithHexString:@"C2BFC3"];
    _borderHighlightColor = [NSColor colorWithHexString:@"AC1326"];
    
    return self;
}

- (id)initWithFrame:(NSRect)frame
{
    return [self initWithFrame:frame sidebarType:TKOSidebarTypeLeft];
}

- (void)setupSidebar
{
    if (_sidebar)
        return;
    
    _sidebar = [NSView viewWithClass:[NSStackView class]];
    _sidebar.orientation = NSUserInterfaceLayoutOrientationVertical;
    _sidebar.alignment = NSLayoutAttributeCenterX;
    _sidebar.spacing = 0.0;
    _sidebar.wantsLayer = YES;
    _sidebar.layer.backgroundColor = [[NSColor lightGrayColor] CGColor];
    
    [self addSubview:_sidebar];
    
    [_sidebar addConstraint:
     [NSLayoutConstraint constraintWithItem:_sidebar
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:80.0]
     ];
    
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:_sidebar
                                  attribute:NSLayoutAttributeLeading
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeLeading
                                 multiplier:1
                                   constant:0]
     ];
    
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[sidebar]|"
                                             options:0
                                             metrics:nil
                                               views:@{@"sidebar": _sidebar}]
     ];
}

- (void)layoutItems
{
    [self.sidebar setViews:nil inGravity:NSStackViewGravityTop];
    [self.sidebar setViews:nil inGravity:NSStackViewGravityBottom];
    NSButton * previous = nil;
    
    for (TKOSidebarViewItem * sidebarViewItem in self.sidebarViewItems)
    {
        NSButton * button = [NSView viewWithClass:[NSButton class]];
        TKOSidebarCell * cell = [[TKOSidebarCell alloc] init];
        
        cell.title = sidebarViewItem.title;
        cell.image = sidebarViewItem.icon;
        cell.target = self;
        cell.action = @selector(selectTab:);
        
        cell.backgroundColor = self.backgroundColor;
        cell.backgroundHighlightColor = self.backgroundHighlightColor;
        cell.imageColor = self.imageColor;
        cell.imageHighlightColor = self.imageHighlightColor;
        cell.textColor = self.textColor;
        cell.textHighlightColor = self.textHighlightColor;
        cell.borderColor = self.borderColor;
        cell.borderHighlightColor = self.borderHighlightColor;
        cell.borderMask = self.borderMask;
        cell.borderHighlightMask = self.borderHighlightMask;
        
        cell.font = [NSFont fontWithName:@"HelveticaNeue-Light" size:11];
        
        cell.showsStateBy = NSChangeBackgroundCellMask;
        cell.highlightsBy = NSChangeBackgroundCellMask;
        cell.bordered = NO;
        cell.buttonType = NSOnOffButton;
        cell.imagePosition = NSImageAbove;
        
        button.cell = cell;
        [self.sidebar addView:button inGravity:sidebarViewItem.gravity];
        
        [button addConstraint:
         [NSLayoutConstraint constraintWithItem:button
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:nil
                                      attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1
                                       constant:62]
         ];
        
        [self.sidebar addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button]|"
                                                 options:0
                                                 metrics:nil
                                                   views:@{@"button": button}]
         ];
        
        cell.borderMask = (sidebarViewItem.gravity == NSStackViewGravityTop) ? TKOBorderMaskBottom : TKOBorderMaskTop;
        
        if (!previous)
            cell.borderHighlightMask = TKOBorderMaskBottom;
        else
            cell.borderHighlightMask = TKOBorderMaskBottom|TKOBorderMaskTop;
        
        previous = button;
    }
    
    NSButton * lastBottomButton = self.sidebar.views.lastObject;
    TKOSidebarCell * cell = lastBottomButton.cell;
    cell.borderHighlightMask = TKOBorderMaskTop;
}

# pragma mark - Properties

- (void)setContentView:(NSView *)contentView
{
    if (!contentView) return;
    if (_contentView == contentView) return;
    
    [_contentView removeFromSuperview];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentView = contentView;
    [self addSubview:_contentView];
    NSDictionary * views = NSDictionaryOfVariableBindings(_contentView, _sidebar);
    
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentView]|"
                                             options:0
                                             metrics:nil
                                               views:views]
     ];
    
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_sidebar][_contentView]|"
                                             options:0
                                             metrics:nil
                                               views:views]
     ];
}

- (void)setBackgroundColor:(NSColor *)backgroundColor
{
    if (_backgroundColor == backgroundColor) return;
    _backgroundColor = backgroundColor.copy;
    self.sidebar.layer.backgroundColor = [_backgroundColor CGColor];
}

# pragma mark - Add/Remove Tabs

- (void)addSidebarViewItem:(TKOSidebarViewItem *)sidebarViewItem
{
    [self.sidebarViewItems addObject:sidebarViewItem];
    [self layoutItems];
}

- (void)insertSidebarViewItem:(TKOSidebarViewItem *)sidebarViewItem atIndex:(NSUInteger)index
{
    [self.sidebarViewItems insertObject:sidebarViewItem atIndex:index];
    [self layoutItems];
}

- (void)removeSidebarViewItem:(TKOSidebarViewItem *)sidebarViewItem
{
    [self.sidebarViewItems removeObject:sidebarViewItem];
    [self layoutItems];
}

# pragma mark - Selection

- (IBAction)selectTab:(id)sender
{
    NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter postNotificationName:TKOSidebarViewWillChangeSelectionNotification object:self];
    
    NSButton * selectedButton = sender;
    
    for (NSButton * button in self.sidebar.views)
        if ([button isKindOfClass:[NSButton class]])
            [button setState:(button == selectedButton) ? 1 : 0];
    
    [self.sidebar.views indexOfObject:sender];
    self.selectedIndex = [self.sidebar.views indexOfObject:sender];
    TKOSidebarViewItem * sidebarItem = self.sidebarViewItems[self.selectedIndex];
    self.contentView = sidebarItem.view;
    [defaultCenter postNotificationName:TKOSidebarViewDidChangeSelectionNotification object:self];
}

- (void)selectSidebarViewItem:(TKOSidebarViewItem *)sidebarViewItem
{
    NSButton * button = self.sidebar.views[[self.sidebarViewItems indexOfObject:sidebarViewItem]];
    [self selectTab:button];
}

- (void)selectSidebarViewItemAtIndex:(NSUInteger)index
{
    [self selectTab:[self.sidebarViewItems objectAtIndex:index]];
}

# pragma mark - Navigation

- (void)selectFirstTabViewItem:(id)sender
{
    [self selectTab:self.sidebar.views.firstObject];
}

- (void)selectLastTabViewItem:(id)sender
{
    [self selectTab:self.sidebar.views.lastObject];
}

- (void)selectNextTabViewItem:(id)sender
{
    if (self.selectedIndex < self.sidebar.views.count - 1)
        [self selectTab:self.sidebar.views[self.selectedIndex + 1]];
}

- (void)selectPreviousTabViewItem:(id)sender
{
    if (self.selectedIndex > 0)
        [self selectTab:self.sidebar.views[self.selectedIndex - 1]];
}

# pragma mark - Query

- (NSUInteger)numberOfSidebarViewItems;
{
    return self.sidebarViewItems.count;
}

- (NSUInteger)indexOfSidebarViewItem:(TKOSidebarViewItem *)sidebarViewItem			// NSNotFound if not found
{
    return [self.sidebarViewItems indexOfObject:sidebarViewItem];
}

- (TKOSidebarViewItem *)sidebarViewItemAtIndex:(NSUInteger)index                    // May raise an NSRangeException
{
    return [self.sidebarViewItems objectAtIndex:index];
}

@end

NSString * TKOSidebarViewWillChangeSelectionNotification = @"TKOSidebarViewWillChangeSelectionNotification";
NSString * TKOSidebarViewDidChangeSelectionNotification = @"TKOSidebarViewDidChangeSelectionNotification";
