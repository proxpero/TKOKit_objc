//
//  TKOProblemEditorHeaderView.m
//  ProblemEditor
//
//  Created by Todd Olsen on 6/13/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOProblemEditorHeaderView.h"
#import "NSView+TKOKit.h"

#import "TKOProblemEditorPreviewWindowController.h"

@interface TKOProblemEditorHeaderView ()

@property (nonatomic) NSStackView * header;
@property (nonatomic) NSMutableArray * items;

@property (nonatomic) TKOProblemEditorPreviewWindowController * previewController;

@end

@implementation TKOProblemEditorHeaderView

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
    
    if (!self.previewController) {
        self.previewController = [[TKOProblemEditorPreviewWindowController alloc] init];
    }
    
    self.items = [NSMutableArray arrayWithArray:@[[NSImage imageNamed:NSImageNameAddTemplate]]];
    [self layoutButtons];
    
    return self;
}

- (void)layoutButtons
{
    NSButton * button;
    
    // Leading
    
    // Center
    
    // Trailing
    
    button = [self buttonForImage:[NSImage imageNamed:NSImageNameQuickLookTemplate]];
    button.target = self;
    button.action = @selector(showPreviewAction:);
    
    [self.header addView:button inGravity:NSStackViewGravityTrailing];
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

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"html"])
    {
        NSString * html = [object valueForKey:@"html"];
        [self.previewController setHtml:html];
    }
}

# pragma mark - Button Actions

- (void)showPreviewAction:(id)sender
{
    [self.previewController showWindow:nil];
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
