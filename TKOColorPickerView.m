//
//  TKOColorPickerView.m
//  TKOKit
//
//  Created by Todd Olsen on 1/30/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOColorPickerView.h"
#import "NSView+TKOKit.h"
#import "NSColor+TKOKit.h"
#import "TKOControlCell.h"

@interface TKOPaletteViewController : NSViewController

@property (strong, nonatomic) NSColor * selectedColor;
- (id)initWithMatrix:(NSMatrix *)matrix;

@end

@interface TKOPaletteButton : NSButton
@end

@interface TKOColorPickerView()

@property (strong, nonatomic) TKOPaletteButton * paletteButton;
@property (strong, nonatomic) NSButton * colorPanelButton;
@property (strong, nonatomic) NSPopover * palettePopover;
@property (strong, nonatomic) TKOPaletteViewController * paletteViewController;

@end

@interface TKOPaletteCell : NSButtonCell
@property (nonatomic) BOOL showsPullDownImage;
@end

@interface TKOPanelButtonCell : TKOControlCell
@end

@implementation TKOColorPickerView

+ (Class)cellClass
{
    return [NSActionCell class];
}

# pragma mark - Lifecycle

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;

    [self setWantsLayer:YES];
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 4;
    
    [self configureSubviews];
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSWindowWillCloseNotification
                                                  object:[NSColorPanel sharedColorPanel]];

}

- (void)awakeFromNib
{
    NSData * lastColorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"TKOPickerLastSelectedColorKey"];
    NSColor * lastColor = [NSKeyedUnarchiver unarchiveObjectWithData:lastColorData];
    if (!lastColor)
        lastColor = [NSColor blueColor];
    [self setColorWithColor:lastColor];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:66]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:21]];
}

- (void)configureSubviews
{
    [self configurePaletteButton];
    [self configureColorPanelButton];
    
    [self setSubviews:@[_paletteButton, _colorPanelButton]];
    NSDictionary * views = NSDictionaryOfVariableBindings(_paletteButton, _colorPanelButton);
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_paletteButton(==46)][_colorPanelButton]|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    for (NSView * view in views.allValues) {
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                 options:0
                                                 metrics:nil
                                                   views:@{@"view": view}]];
    }
}

- (void)configurePaletteButton
{
    if (_paletteButton)
        return;
    
    _paletteButton = [[TKOPaletteButton alloc] initWithFrame:NSMakeRect(0, 0, 46, 21)];
//    [_paletteButton setTitle:@""];
//    [_paletteButton setBordered:NO];
//    
//    TKOPaletteCell * cell = _paletteButton.cell;
//    NSLog(@"cell class %@", NSStringFromClass([cell class]));
//    
//    [_paletteButton.cell setHighlightsBy:NSNoCellMask];
    [_paletteButton setWantsLayer:YES];
    _paletteButton.layer.backgroundColor = [self.selectedColor CGColor];
    [_paletteButton setTarget:self];
    [_paletteButton setAction:@selector(showPopover:)];
    [_paletteButton addConstraint:
     [NSLayoutConstraint constraintWithItem:_paletteButton
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:46]];
}

- (void)configureColorPanelButton
{
    if (_colorPanelButton)
        return;
    
    _colorPanelButton = [NSView viewWithClass:[NSButton class]];
    
    TKOPanelButtonCell * cell = [[TKOPanelButtonCell alloc] init];
    [cell setImageScaling:NSImageScaleProportionallyDown];
    [cell setHighlightsBy:NSChangeBackgroundCellMask];
    NSColor * borderColor = [self.selectedColor blendedColorWithFraction:.85
                                                                 ofColor:[NSColor grayColor]];
    [cell setBorderColor:borderColor];
    [cell setBorderMask:TKOBorderMaskLeft];
    [_colorPanelButton setCell:cell];
    
    NSColorPanel * colorPanel = [NSColorPanel sharedColorPanel];
    [colorPanel setTarget:self];
    [colorPanel setAction:@selector(changeColor:)];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(colorPanelWillClose:)
                                                 name:NSWindowWillCloseNotification
                                               object:colorPanel];
    
    [_colorPanelButton setBordered:NO];
    [_colorPanelButton setTitle:@""];
    [_colorPanelButton setTarget:self];
    [_colorPanelButton setAction:@selector(showOrHideColorPanel:)];
}

# pragma mark - Color Panel

- (void)showOrHideColorPanel:(id)sender
{
    if (self.colorPanelButton.state == NSOnState) {
        [NSApp performSelector:@selector(orderFrontColorPanel:)
                    withObject:sender];
    } else {
        NSColorPanel * colorPanel = [NSColorPanel sharedColorPanel];
        [colorPanel orderOut:sender];
    }
}

- (void)colorPanelWillClose:(NSNotification *)notification
{
    [self.colorPanelButton setState:NSOffState];
}

# pragma mark - Palette Popover

- (void)showPopover:(id)sender
{
    if (!_palettePopover) {
        _palettePopover = [[NSPopover alloc] init];
        [_palettePopover setBehavior:NSPopoverBehaviorTransient];
        
        
        
        _paletteViewController = [[TKOPaletteViewController alloc] initWithMatrix:[self colorMatrix]];
        [_palettePopover setContentViewController:_paletteViewController];
    }
    [self.palettePopover showRelativeToRect:self.paletteButton.bounds
                                     ofView:sender
                              preferredEdge:NSMaxYEdge];
}

- (NSMatrix *)colorMatrix
{
    static NSMatrix * matrix = nil;
    if (matrix)
        return matrix;
    
    NSView * view = [NSView viewWithClass:[NSView class]];
    [view setWantsLayer:YES];
    [view.layer setBackgroundColor:[[NSColor whiteColor] CGColor]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:237]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:114]];
    
    matrix = [[NSMatrix alloc] initWithFrame:NSZeroRect
                                        mode:NSRadioModeMatrix
                                   cellClass:[TKOControlCell class]
                                numberOfRows:5
                             numberOfColumns:6];
    [matrix setTranslatesAutoresizingMaskIntoConstraints:NO];
    [matrix setCellSize:NSMakeSize(37, 20)];
    [matrix setIntercellSpacing:NSMakeSize(1, 1)];
    [matrix setAutorecalculatesCellSize:NO];
    [matrix setAutosizesCells:NO];
    
5//                         [NSColor colorWithHexString:@"44b3e5"], // blue
//                         [NSColor colorWithHexString:@"7fea41"],
//                         [NSColor colorWithHexString:@"ffe43a"],
//                         [NSColor colorWithHexString:@"ffbf5d"],
//                         [NSColor colorWithHexString:@"fe444a"],
//                         [NSColor colorWithHexString:@"ad19bd"],
//                         [NSColor colorWithHexString:@"1b9bcf"], // blue
//                         [NSColor colorWithHexString:@"40ca14"],
//                         [NSColor colorWithHexString:@"f6d305"],
//                         [NSColor colorWithHexString:@"ffa700"],
//                         [NSColor colorWithHexString:@"ff0202"],
//                         [NSColor colorWithHexString:@"780089"],
//                         [NSColor colorWithHexString:@"037da7"], // blue
//                         [NSColor colorWithHexString:@"63b426"],
//                         [NSColor colorWithHexString:@"eaba00"],
//                         [NSColor colorWithHexString:@"fa9d00"],
//                         [NSColor colorWithHexString:@"e20200"],
//                         [NSColor colorWithHexString:@"5e006f"],
//                         [NSColor colorWithHexString:@"02567c"], // blue
//                         [NSColor colorWithHexString:@"418d0b"],
//                         [NSColor colorWithHexString:@"cf9400"],
//                         [NSColor colorWithHexString:@"df7b01"],
//                         [NSColor colorWithHexString:@"bf0000"],
//                         [NSColor colorWithHexString:@"44004c"],
//                         [NSColor colorWithHexString:@"ffffff"], // white
//                         [NSColor colorWithHexString:@"d5d5d5"],
//                         [NSColor colorWithHexString:@"aaaaaa"],
//                         [NSColor colorWithHexString:@"808080"],
//                         [NSColor colorWithHexString:@"555555"],
//                         [NSColor colorWithHexString:@"000000"]
                         ];
    
    // myMatrix.cells: the order of cells goes left to right, and top to bottom, like reading English.
    [matrix.cells enumerateObjectsUsingBlock:^(TKOControlCell * cell, NSUInteger idx, BOOL *stop) {
        [cell setBordered:NO];
        [cell setHighlightsBy:NSNoCellMask];
        [cell setTitle:@""];
        [cell setHasAdaptiveBorderColor:YES];
        [cell setBorderMask:TKOBorderMaskTop|TKOBorderMaskRight|TKOBorderMaskBottom|TKOBorderMaskLeft];
        [cell setBackgroundColor:colors[idx]];
    }];
    
    [matrix setTarget:self];
    [matrix setAction:@selector(setColorAction:)];

    return matrix;
}

# pragma mark - Actions

- (void)changeColor:(id)sender // [NSColorPanel sharedColorPanel] action
{
    [self setColorWithColor:[[NSColorPanel sharedColorPanel] color]];
}

- (void)setColorAction:(id)sender // self.paletteButton action
{
    NSColor * color = [[sender selectedCell] backgroundColor];
    [self setColorWithColor:color];
    [[NSColorPanel sharedColorPanel] setColor:color];
    [self.palettePopover close];
}

- (void)setColorWithColor:(NSColor *)color
{
    self.paletteButton.layer.backgroundColor = [color CGColor];
    NSColor * borderColor = [color blendedColorWithFraction:.85
                                                    ofColor:[NSColor grayColor]];
    self.layer.borderColor = [borderColor CGColor];
    [self.colorPanelButton.cell setBorderColor:borderColor];
    [self setSelectedColor:color];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:color]
                                              forKey:@"TKOPickerLastSelectedColorKey"];
    [self sendAction:[self.cell action]
                  to:[self.cell target]];
}

@end



@implementation TKOPaletteViewController

- (id)initWithMatrix:(NSMatrix *)matrix
{
    self = [[TKOPaletteViewController alloc] initWithNibName:nil
                                                      bundle:nil];
    if (!self)
        return nil;
    
    NSView * view = [NSView viewWithClass:[NSView class]];
    [view setWantsLayer:YES];
    [view.layer setBackgroundColor:[[NSColor whiteColor] CGColor]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:237]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:114]];

    [view addSubview:matrix];
    NSDictionary * views = NSDictionaryOfVariableBindings(matrix);
    [view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[matrix]-5-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    [view addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[matrix]-5-|"
                                             options:0
                                             metrics:nil
                                               views:views]];
    [self setView:view];

    return self;
}

@end



@implementation TKOPaletteButton

+ (Class)cellClass
{
    return [TKOPaletteCell class];
}

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (!self)
        return nil;
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];

    [self setTitle:@""];
    [self setBordered:NO];
    [self.cell setHighlightsBy:NSNoCellMask];
    
    NSTrackingArea * trackingArea = [[NSTrackingArea alloc] initWithRect:frameRect
                                                                 options:NSTrackingMouseEnteredAndExited|NSTrackingActiveInActiveApp
                                                                   owner:self
                                                                userInfo:nil];
    [self addTrackingArea:trackingArea];

    return self;
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    [self.cell setShowsPullDownImage:YES];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    [self.cell setShowsPullDownImage:NO];
}

@end

@implementation TKOPaletteCell

- (void)setShowsPullDownImage:(BOOL)showsPullDownImage
{
    if (_showsPullDownImage == showsPullDownImage)
        return;
    _showsPullDownImage = showsPullDownImage;
    [self.controlView setNeedsDisplay:YES];
}

+ (NSImage *)popupImage
{
    static NSImage *ret = nil;
    if (ret == nil) {
        ret = [NSImage imageNamed:@"TKOPullDownImage"];
    }
    return ret;
}

- (NSRect)popupRectWithFrame:(NSRect)cellFrame
{
    NSRect popupRect = NSZeroRect;
    popupRect.size = [[TKOPaletteCell popupImage] size];
    popupRect.origin = NSMakePoint(NSMaxX(cellFrame) - NSWidth(popupRect) - 3, NSMidY(cellFrame) - NSHeight(popupRect) / 2);
    
    return popupRect;
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame
                       inView:(NSView *)controlView
{
    if (self.showsPullDownImage)
        [[TKOPaletteCell popupImage] drawInRect:[self popupRectWithFrame:cellFrame]
                                       fromRect:NSZeroRect
                                      operation:NSCompositeSourceOver
                                       fraction:1.0
                                 respectFlipped:YES
                                          hints:nil];
}

@end



@implementation TKOPanelButtonCell

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSImage * colorPanelImage = [NSImage imageNamed:NSImageNameColorPanel];
    NSRect rect = NSInsetRect(cellFrame, 3.0, 3.0);
    [colorPanelImage drawInRect:rect
                       fromRect:NSZeroRect
                      operation:NSCompositeSourceOver
                       fraction:1
                 respectFlipped:YES
                          hints:nil];

}

@end

