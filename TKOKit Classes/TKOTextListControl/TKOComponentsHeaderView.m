//
//  TKOComponentsHeaderView.m
//  ProblemEditor
//
//  Created by Todd Olsen on 6/13/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOComponentsHeaderView.h"
#import "NSView+TKOKit.h"

@interface TKOComponentsHeaderView ()

@property (nonatomic) NSStackView * header;
@property (nonatomic) NSMutableArray * items;

@end

@implementation TKOComponentsHeaderView

- (id)init
{
    self = [super initWithFrame:NSZeroRect];
    if (!self) return nil;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    _header = [NSView viewWithClass:[NSStackView class]];
    _header.orientation = NSUserInterfaceLayoutOrientationHorizontal;
    _header.alignment = NSLayoutAttributeCenterY;
    _header.spacing = 0;
    
    NSView * border = [NSView viewWithClass:[NSView class]];
    border.wantsLayer = YES;
    border.layer.backgroundColor = [[NSColor darkGrayColor] CGColor];
    
    [self setSubviews:@[_header, border]];
    NSDictionary * views = NSDictionaryOfVariableBindings(_header, border);
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_header(28)][border(1)]|"
                                             options:0
                                             metrics:nil
                                               views:views]
     ];
    
    for (NSView * view in self.subviews)
    {
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                 options:0
                                                 metrics:nil
                                                   views:NSDictionaryOfVariableBindings(view)]
         ];
    }
    
    self.items = [NSMutableArray arrayWithArray:@[[NSImage imageNamed:NSImageNameAddTemplate]]];
    [self layoutButtons];
    
    return self;
}

- (void)layoutButtons
{
    // Leading
    [self.header addView:[self buttonForImage:[NSImage imageNamed:NSImageNameActionTemplate]]
               inGravity:NSStackViewGravityLeading];
    [self.header addView:[self buttonForImage:[NSImage imageNamed:NSImageNameQuickLookTemplate]]
               inGravity:NSStackViewGravityLeading];
    
    // Center
    
    for (NSImage * image in self.items)
    {
        NSButton * button = [self buttonForImage:image];
        [self.header addView:button inGravity:NSStackViewGravityCenter];
    }

    // Trailing
    [self.header addView:[self buttonForImage:[NSImage imageNamed:@"TKOTagsTemplate"]]
               inGravity:NSStackViewGravityTrailing];
    [self.header addView:[self buttonForImage:[NSImage imageNamed:@"TKOStandardsTemplate"]]
               inGravity:NSStackViewGravityTrailing];
    


}

- (NSButton *)buttonForImage:(NSImage *)image
{
    NSButton * button = [NSView viewWithClass:[NSButton class]];
    button.bordered = NO;
    button.image = image;
    button.imagePosition = NSImageOnly;
    [button addConstraintsForWidth:32 height:28];
    return button;
}

# pragma mark - Components Data Source

- (NSUInteger)numberOfComponents
{
    return self.items.count;
}

- (NSView *)viewForComponentAtIndex:(NSUInteger)index
{
    return self.items[index];
}

@end
