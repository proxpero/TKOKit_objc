//
//  TKODisclosingView.m
//
//  Created by Todd Olsen on 3/5/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKODisclosingView.h"
#import "NSView+TKOKit.h"

@import QuartzCore;

@interface TKODisclosingView ()

@property (nonatomic) BOOL disclosureIsClosed;
@property (strong, nonatomic) NSView * headerView;
@property (strong, nonatomic) NSButton * disclosureButton;
@property (strong, nonatomic) NSTextField * titleField;

@property (strong, nonatomic) NSLayoutConstraint * heightConstraint;

@end

@implementation TKODisclosingView

- (id)initWithTitle:(NSString *)title
        contentView:(NSView *)contentView
{
    return [self initWithTitle:title
                   contentView:contentView
                 accessoryView:nil];
}

- (id)initWithTitle:(NSString *)title
        contentView:(NSView *)contentView
      accessoryView:(NSView *)accessoryView
{
    self = [super initWithFrame:NSZeroRect];
    if (!self)
        return nil;
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.accessoryView = accessoryView;
    self.accessoryView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self configureSubviews];
    
    self.title = title;
    self.contentView = contentView;
    
    return self;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self configureSubviews];
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configureSubviews];
}

- (void)setTitle:(NSString *)title
{
    if ([_title isEqualToString:title])
        return;
    
    _title = title.copy;
    self.titleField.stringValue = _title;
}

- (void)setContentView:(NSView *)contentView
{
    if (_contentView == contentView)
        return;
    
    [_contentView removeFromSuperview];
    _contentView = contentView;
    
    [self addSubview:_contentView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_contentView)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_headerView][_contentView]-(0@600)-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_headerView, _contentView)]];
}

- (void)disclosureButtonAction:(id)sender
{
    self.disclosureIsClosed = self.disclosureButton.state;
    [self toggleContentViewAction];
}

- (void)toggleContentViewAction
{
    if (!self.disclosureIsClosed)
    {
        CGFloat distanceFromHeaderToBottom = NSMinY(self.bounds) - NSMinY(self.headerView.frame);
        if (!self.heightConstraint)
        {
            self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.headerView
                                                                 attribute:NSLayoutAttributeBottom
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1
                                                                  constant:distanceFromHeaderToBottom];
        }
        self.heightConstraint.constant = distanceFromHeaderToBottom;
        [self addConstraint:self.heightConstraint];
        
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            self.heightConstraint.animator.constant = 0;
        } completionHandler:nil];
    }
    else
    {
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            self.heightConstraint.animator.constant -= self.contentView.frame.size.height;
        } completionHandler:^{
            [self removeConstraint:self.heightConstraint];
        }];
    }
}

- (void)configureSubviews
{
    if (self.headerView)
        return;
    
    self.headerView = [NSView viewWithClass:[NSView class]];
    [self.headerView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.headerView
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:47.0]];
    
    self.disclosureButton = [NSView viewWithClass:[NSButton class]];
    self.disclosureButton.bezelStyle = NSDisclosureBezelStyle;
    self.disclosureButton.buttonType = NSOnOffButton;
    self.disclosureButton.imagePosition = NSImageOnly;
    self.disclosureButton.target = self;
    self.disclosureButton.action = @selector(disclosureButtonAction:);
    self.disclosureButton.state = NSOnState;
    [self.disclosureButton addConstraintsForWidth:27 height:27];

    self.titleField = [NSView viewWithClass:[NSTextField class]];
    self.titleField.editable = NO;
    self.titleField.selectable = NO;
    self.titleField.bordered = NO;
    self.titleField.backgroundColor = [NSColor controlColor];
    self.titleField.font = [NSFont boldSystemFontOfSize:13.0];
    self.titleField.textColor = [NSColor secondaryLabelColor];
    
    if (!self.accessoryView)
    {
        self.accessoryView = [NSView viewWithClass:[NSView class]];
        [self.accessoryView addConstraintsForWidth:0 height:0];
    }
    
    [self.headerView addSubview:self.disclosureButton];
    [self.headerView addSubview:self.titleField];
    [self.headerView addSubview:self.accessoryView];
    
    NSDictionary * views = NSDictionaryOfVariableBindings(_disclosureButton, _titleField, _accessoryView);
    [self.headerView addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(8)-[_disclosureButton]-(1)-[_titleField]-(1)-[_accessoryView]-(15)-|"
                                             options:0
                                             metrics:nil
                                               views:views]
     ];

    [self.headerView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.disclosureButton
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.headerView
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]
     ];

    [self.headerView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.disclosureButton
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.titleField
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:1]
     ];
    
    [self.headerView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.accessoryView
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self.headerView
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:2]
     ];
    
    [self addSubview:self.headerView];
    
    views = @{@"_headerView": _headerView};
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_headerView]"
                                             options:0
                                             metrics:nil
                                               views:views]
     ];
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_headerView]|"
                                             options:0
                                             metrics:nil
                                               views:views]
     ];
    
//    NSBox * separator = [NSView horizontalSeparator];    
//    [self addSubview:separator];
//    
//    views = @{@"separator": separator};
//    [self addConstraints:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separator]|"
//                                             options:0
//                                             metrics:nil
//                                               views:views]
//     ];
//    [self addConstraints:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[separator]|"
//                                             options:0
//                                             metrics:nil
//                                               views:views]
//     ];
}



@end
