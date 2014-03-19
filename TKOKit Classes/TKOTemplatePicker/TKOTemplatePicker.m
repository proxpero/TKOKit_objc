//
//  TKOTemplatePicker.m
//  TKOProblemTemplateClassDemo
//
//  Created by Todd Olsen on 3/10/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOTemplatePicker.h"
#import "TKOButtonCell.h"
#import "TKOControl.h"
#import "TKOTextTabCell.h"
#import "NSView+TKOKit.h"

@interface TKOActionCell : NSActionCell
@end

@interface TKOTemplatePicker ()

@property (strong, nonatomic) NSTextField * titleField;
@property (strong, nonatomic) NSView * buttonContainer;

@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSArray * buttons;

@end

@implementation TKOTemplatePicker

- (id)initWithTitle:(NSString *)title
{
    self = [self initWithFrame:NSZeroRect];
    if (!self)
        return nil;

    self.title = title.copy;
    [self configureSubviews];
    
    return self;
}

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (!self)
        return nil;
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:self
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:268.0]];
    
    return self;
}

# pragma mark - UI

- (void)configureSubviews
{
    NSString * verticalLayoutConstraintFormat;
    NSDictionary * views;
    
    NSBox * separator2 = [NSView viewWithClass:[NSBox class]];
    separator2.boxType = NSBoxSeparator;
    
    _buttonContainer = [NSView viewWithClass:[NSView class]];
    
    [self addSubview:_buttonContainer];
    [self addSubview:separator2];
    
    if (self.title)
    {
        _titleField = [NSView viewWithClass:[NSTextField class]];
        _titleField.font = [NSFont boldSystemFontOfSize:13];
        _titleField.textColor = [NSColor darkGrayColor];
        _titleField.editable = NO;
        _titleField.bordered = NO;
        _titleField.selectable = NO;
        _titleField.drawsBackground = NO;
        [self addSubview:_titleField];
        
        NSBox * separator1 = [NSView viewWithClass:[NSBox class]];
        separator1.boxType = NSBoxSeparator;
        [self addSubview:separator1];

        views = NSDictionaryOfVariableBindings(_titleField, _buttonContainer, separator1, separator2);
        verticalLayoutConstraintFormat = @"V:|-(10)-[_titleField(==17)]-(10)-[separator1]-3-[_buttonContainer]-3-[separator2]|";
        
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_titleField]"
                                                 options:0
                                                 metrics:nil
                                                   views:views]
         ];
        
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separator1]|"
                                                 options:0
                                                 metrics:nil
                                                   views:views]
         ];
        
        _titleField.stringValue = _title;
    }
    else
    {
        views = NSDictionaryOfVariableBindings(_buttonContainer, separator2);
        verticalLayoutConstraintFormat = @"V:|-3-[_buttonContainer]-3-[separator2]|";
    }
    
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:verticalLayoutConstraintFormat
                                             options:0
                                             metrics:nil
                                               views:views]
     ];
    
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-3-[_buttonContainer]-3-|"
                                             options:0
                                             metrics:nil
                                               views:views]
     ];

    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separator2]|"
                                             options:0
                                             metrics:nil
                                               views:views]
     ];
}

- (void)drawControlInterior:(TKOControl *)control
{
    if ([control.cell state])
    {
        control.layer.borderWidth = 1.0;
        control.layer.cornerRadius = 5.0;
        control.layer.backgroundColor = [[NSColor whiteColor] CGColor];
    }
    else
    {
        control.layer.borderWidth = 0.0;
        control.layer.cornerRadius = 0.0;
        control.layer.backgroundColor = [[NSColor clearColor] CGColor];
    }
}

- (TKOControl *)controlWithTitle:(NSString *)title
{
    TKOControl * control = [NSView viewWithClass:[NSControl class]];
    control.wantsLayer = YES;
    control.layer.opaque = YES;
    control.layer.borderColor = [[NSColor blueColor] CGColor];
    //    control.layer.cornerRadius = 5.0;
    
    [self drawControlInterior:control];
    
    control.cell = [[TKOActionCell alloc] init];
    [control sendActionOn:NSLeftMouseDownMask];
    control.target = self;
    control.action = @selector(selectControl:);
    
    NSTextField * textfield = [NSView viewWithClass:[NSTextField class]];
    textfield.font = [NSFont systemFontOfSize:[NSFont systemFontSize]];
    textfield.textColor = [NSColor darkGrayColor];
    textfield.editable = NO;
    textfield.bordered = NO;
    textfield.selectable = NO;
    textfield.drawsBackground = NO;
    
    textfield.stringValue = title;
    
    [control addConstraint:
     [NSLayoutConstraint constraintWithItem:control
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:40.0]
     ];
    
    [control addSubview:textfield];
    
    [control addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[textField]"
                                             options:0
                                             metrics:nil
                                               views:@{@"textField": textfield}]
     ];
    [control addConstraint:
     [NSLayoutConstraint constraintWithItem:textfield
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:control
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]
     ];
    
    return control;
}

# pragma mark - Delegate and Data Source

- (void)setDelegate:(id<TKOTemplatePickerDelegate>)delegate
{
    if (_delegate == delegate)
        return;
    
    NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
    
    if ([_delegate respondsToSelector:@selector(templatePickerDidChangeSelection:)])
        [defaultCenter removeObserver:_delegate
                                 name:TKOTemplatePickerDidChangeSelectionNotification
                               object:self];
    
    _delegate = delegate;
    
    if ([_delegate respondsToSelector:@selector(templatePickerDidChangeSelection:)])
        [defaultCenter addObserver:_delegate
                          selector:@selector(templatePickerDidChangeSelection:)
                              name:TKOTemplatePickerDidChangeSelectionNotification
                            object:self];
}

- (void)setDataSource:(id<TKOTemplatePickerDataSource>)dataSource
{
    if (_dataSource == dataSource)
        return;
    
    _dataSource = dataSource;
        
    [self reloadData];
}

- (void)reloadData
{
    NSMutableArray * newItems = [NSMutableArray new];
    
    for (NSUInteger i = 0, count = [self.dataSource templatePickerNumberOfItems:self] ; i < count; i++)
    {
        [newItems addObject:[self.dataSource templatePicker:self
                                                itemAtIndex:i]];
    }
    
    NSMutableArray * controls = [NSMutableArray new];
    
    for (id item in newItems)
    {
        TKOControl * control = [self controlWithTitle:[self.dataSource templatePicker:self
                                                                         titleForItem:item]];
        [control.cell setRepresentedObject:item];
        [controls addObject:control];
    }
    
    // Layout
    
    [self.buttonContainer setSubviews:controls];
    NSControl * previous = nil;
    
    for (TKOControl * control in controls)
    {
        [self.buttonContainer addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[control]|"
                                                 options:0
                                                 metrics:nil
                                                   views:@{@"control": control}]
         ];
        [self.buttonContainer addConstraint:
         [NSLayoutConstraint constraintWithItem:control
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:(previous != nil ? previous : self.buttonContainer)
                                      attribute:(previous != nil ? NSLayoutAttributeBottom : NSLayoutAttributeTop)
                                     multiplier:1
                                       constant:0]
         ];
        
        previous = control;
    }
    
    if (previous)
    {
        [self.buttonContainer addConstraint:
         [NSLayoutConstraint constraintWithItem:previous
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.buttonContainer
                                      attribute:NSLayoutAttributeBottom
                                     multiplier:1
                                       constant:0]];
    }
}

# pragma mark - Selection

- (void)selectControl:(id)sender
{
    for (TKOControl * control in self.buttonContainer.subviews)
    {
        [control.cell setState:(control == sender) ? NSOnState : NSOffState];
        [self drawControlInterior:control];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:TKOTemplatePickerDidChangeSelectionNotification
                                                        object:self];

}

- (id)selectedItem
{
    for (TKOControl * control in self.buttonContainer.subviews)
        if ([control.cell state] == NSOnState)
            return [control.cell representedObject];

    return nil;
}

- (void)setSelectedItem:(id)selectedItem
{
    for (TKOControl * control in self.buttonContainer.subviews)
    {
        if ([[control.cell representedObject] isEqual:selectedItem])
            [control.cell setState:1];
        else
            [control.cell setState:0];
        [self drawControlInterior:control];
    }
}

@end

NSString * TKOTemplatePickerDidChangeSelectionNotification = @"TKOTemplatePickerDidChangeSelectionNotification";

@implementation TKOActionCell

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView { }

@end