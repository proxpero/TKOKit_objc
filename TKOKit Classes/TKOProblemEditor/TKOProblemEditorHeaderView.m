//
//  TKOProblemEditorHeaderView.m
//  ProblemEditor
//
//  Created by Todd Olsen on 6/13/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOProblemEditorHeaderView.h"
#import "NSView+TKOKit.h"
#import "NSImage+TKOKit.h"

#import "TKOImageEditorComponentView.h"
#import "TKOPreludeEditorView.h"
#import "TKOQuestionEditorView.h"
#import "TKORomanEditorView.h"
#import "TKOChoicesEditorView.h"

#import "TKOProblemEditorPreviewWindowController.h"

@interface TKOProblemEditorHeaderView ()

@property (nonatomic) NSStackView * header;
@property (nonatomic) NSMutableArray * buttons;

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
    
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:self
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationGreaterThanOrEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:350]
     ];
    
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
    
    [self layoutButtons];
    
    return self;
}

- (void)layoutButtons
{
    NSButton * button;
    
    // Leading
    
    // Center
    
    if (!self.buttons) {
        self.buttons = [NSMutableArray new];
        
        [self.buttons addObject:[self buttonForComponent:[[TKOImageEditorComponentView alloc] init]]];
        [self.buttons addObject:[self buttonForComponent:[[TKOPreludeEditorView alloc] init]]];
        [self.buttons addObject:[self buttonForComponent:[[TKOQuestionEditorView alloc] init]]];
        [self.buttons addObject:[self buttonForComponent:[[TKORomanEditorView alloc] initWithCount:3]]];
        [self.buttons addObject:[self buttonForComponent:[[TKOChoicesEditorView alloc] initWithCount:5]]];
    }
    
    for (NSButton * button in self.buttons)
        [self.header addView:button inGravity:NSStackViewGravityCenter];
    
    // Trailing
    
    button = [NSView viewWithClass:[NSButton class]];
    button.bordered = NO;
    button.image = [NSImage imageNamed:NSImageNameQuickLookTemplate];
    button.imagePosition = NSImageOnly;
    button.buttonType = NSOnOffButton;
    [button.cell setImageScaling:NSImageScaleProportionallyDown];
    [button addConstraintsForWidth:32 height:28];
    button.target = self;
    button.action = @selector(showPreviewAction:);
    
    [self.header addView:button inGravity:NSStackViewGravityTrailing];
}

- (NSButton *)buttonForComponent:(id)component
{
    NSButton * button = [NSView viewWithClass:[NSButton class]];
    button.bordered = NO;
//    button.image = [component image];
    button.attributedTitle = [[NSAttributedString alloc] initWithString:[component title]];
//    button.imagePosition = NSImageOnly;
    button.imagePosition = NSNoImage;
    button.buttonType = NSOnOffButton;

    button.target = self;
    button.action = @selector(componentButtonAction:);

    [button.cell setImageScaling:NSImageScaleProportionallyDown];
    [button.cell setRepresentedObject:component];

    [button addConstraintsForWidth:60 height:28];
    
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

- (void)componentButtonAction:(id)sender
{
    NSButton * button = (NSButton *)sender;
    
    NSMutableAttributedString * attributedTitle = button.attributedTitle.mutableCopy;
    [attributedTitle addAttributes:@{ NSForegroundColorAttributeName : (button.state ? [NSColor blueColor] : [NSColor controlTextColor]) }
                             range:NSMakeRange(0, attributedTitle.length)];
    button.attributedTitle = attributedTitle.copy;
    
    NSMutableArray * components = [NSMutableArray new];
    
    for (NSButton * button in self.buttons) {
        if (button.state) {
            [components addObject:[button.cell representedObject]];
        }
    }
    
    self.components = components.copy;
}

@end

