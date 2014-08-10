//
//  TKOMultipleChoiceAnswerView.m
//  TKOMultipleChoiceAnswerViewDemo
//
//  Created by Todd Olsen on 3/19/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOMultipleChoiceAnswerView.h"
#import "TKOTextTabControl.h"
#import "NSView+TKOKit.h"

@interface TKOMultipleChoiceAnswerView () <TKOTabControlDataSource>

@property (strong, nonatomic) NSTextField * titleField;
@property (strong, nonatomic) NSView * choicesView;

@end

@implementation TKOMultipleChoiceAnswerView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self configureSubviews];
    
    return self;
}

- (void)configureSubviews
{
    static BOOL configured = NO;
    if (configured)
        return;
    
    _titleField = [NSView viewWithClass:[NSTextField class]];
    _titleField.font = [NSFont boldSystemFontOfSize:13];
    _titleField.textColor = [NSColor darkGrayColor];
    _titleField.editable = NO;
    _titleField.bordered = NO;
    _titleField.selectable = NO;
    _titleField.drawsBackground = NO;
    _titleField.stringValue = NSLocalizedString(@"Answer", @"Name for answer inspector");
    
    _choicesView = [NSView viewWithClass:[NSView class]];
    [self setSubviews:@[ _titleField, _choicesView ]];
    
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:_titleField
                                  attribute:NSLayoutAttributeLeading
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeLeading
                                 multiplier:1
                                   constant:15.0]
     ];
    
    [self addConstraint: // Align Leading Edge
     [NSLayoutConstraint constraintWithItem:_choicesView
                                  attribute:NSLayoutAttributeLeading
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:_titleField
                                  attribute:NSLayoutAttributeLeading
                                 multiplier:1
                                   constant:0]
     ];
    
    [self addConstraint: // Trailing Edge
     [NSLayoutConstraint constraintWithItem:self
                                  attribute:NSLayoutAttributeTrailing
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:_choicesView
                                  attribute:NSLayoutAttributeTrailing
                                 multiplier:1
                                   constant:15]
     ];
    
    NSString * horizontalConstrainFormat = @"V:|-(13)-[_titleField(==17)]-(11)-[_choicesView(==36)]-(15)-|";
    NSDictionary * views = NSDictionaryOfVariableBindings(_titleField, _choicesView);
    
    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:horizontalConstrainFormat
                                             options:0
                                             metrics:nil
                                               views:views]
     ];
   
    configured = YES;
}

- (void)setDataSource:(id<TKOMultipleChoiceAnswerDataSource>)dataSource
{
    if (_dataSource == dataSource)
        return;
    _dataSource = dataSource;
    
    multipleChoiceAnswerDataSourceRespondsTo.backgroundColorForMultipleChoiceAnswerView = [_dataSource respondsToSelector:@selector(backgroundColorForMultipleChoiceAnswerView:)];
    multipleChoiceAnswerDataSourceRespondsTo.backgroundHighlightColorForMultipleChoiceAnswerView = [_dataSource respondsToSelector:@selector(backgroundHighlightColorForMultipleChoiceAnswerView:)];
    multipleChoiceAnswerDataSourceRespondsTo.borderColorForMultipleChoiceAnswerView = [_dataSource respondsToSelector:@selector(borderColorForMultipleChoiceAnswerView:)];
    multipleChoiceAnswerDataSourceRespondsTo.borderHighlightColorForMultipleChoiceAnswerView = [_dataSource respondsToSelector:@selector(borderHighlightColorForMultipleChoiceAnswerView:)];
    multipleChoiceAnswerDataSourceRespondsTo.textColorForMultipleChoiceAnswerView = [_dataSource respondsToSelector:@selector(textColorForMultipleChoiceAnswerView:)];
    multipleChoiceAnswerDataSourceRespondsTo.textHighlightColorForMultipleChoiceAnswerView = [_dataSource respondsToSelector:@selector(textHighlightColorForMultipleChoiceAnswerView:)];
    multipleChoiceAnswerDataSourceRespondsTo.fontForMultipleChoiceAnswerView = [_dataSource respondsToSelector:@selector(fontForMultipleChoiceAnswerView:)];

    [self reloadData];
}

- (void)reloadData
{
    NSMutableArray * buttons = [NSMutableArray new];
    NSUInteger i;
    NSUInteger count = [self.dataSource multipleChoiceViewNumberOfChoices:self];
    for (i = 0; i < count; i++)
        [buttons addObject:[self buttonForIndex:i]];
    
    [self.choicesView setSubviews:buttons];
   
    NSControl * prev = nil;
    for (TKOMCButton * button in self.choicesView.subviews)
    {
        [self.choicesView addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|"
                                                 options:0
                                                 metrics:nil
                                                   views:@{@"button":button}]
         ];
        
        [self.choicesView addConstraint:
         [NSLayoutConstraint constraintWithItem:button
                                      attribute:NSLayoutAttributeLeading
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:(prev != nil ? prev : self.choicesView)
                                      attribute:(prev != nil ? NSLayoutAttributeTrailing : NSLayoutAttributeLeading)
                                     multiplier:1
                                       constant:(prev != nil ? 3 : 0)]
         ];
        
        if (prev != nil)
        {
            [self addConstraint:
             [NSLayoutConstraint constraintWithItem:button
                                          attribute:NSLayoutAttributeWidth
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:prev
                                          attribute:NSLayoutAttributeWidth
                                         multiplier:1
                                           constant:0]];
        }
        prev = button;
    }
    
    if (prev)
    {
        [self.choicesView addConstraint:
         [NSLayoutConstraint constraintWithItem:prev
                                      attribute:NSLayoutAttributeTrailing
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.choicesView
                                      attribute:NSLayoutAttributeTrailing
                                     multiplier:1
                                       constant:0]];
    }
    [self setSelectedIndex:NSNotFound];
}

- (void)layoutButtons:(NSArray *)buttons
{
    NSControl * prev = nil;
    for (NSControl * button in self.choicesView.subviews)
    {
        [self.choicesView addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|"
                                                 options:0
                                                 metrics:nil
                                                   views:@{@"button":button}]
         ];
        
        [self.choicesView addConstraint:
         [NSLayoutConstraint constraintWithItem:button
                                      attribute:NSLayoutAttributeLeading
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:(prev != nil ? prev : self.choicesView)
                                      attribute:(prev != nil ? NSLayoutAttributeTrailing : NSLayoutAttributeLeading)
                                     multiplier:1
                                       constant:(prev != nil ? 0 : 1)]
         ];
        
        if (prev) {
            [self.choicesView addConstraint:
             [NSLayoutConstraint constraintWithItem:prev
                                          attribute:NSLayoutAttributeTrailing
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:self.choicesView
                                          attribute:NSLayoutAttributeTrailing
                                         multiplier:1
                                           constant:0]];
        }
        prev = button;
    }
}

- (NSControl *)buttonForIndex:(NSUInteger)index
{
    TKOMCButton * button = [NSView viewWithClass:[TKOMCButton class]];
    NSActionCell * cell = [[NSActionCell alloc] init];
    cell.target = self;
    cell.action = @selector(selectAnswerAction:);
    button.cell = cell;
    
    button.titleTextColor = multipleChoiceAnswerDataSourceRespondsTo.textColorForMultipleChoiceAnswerView ? [self.dataSource textColorForMultipleChoiceAnswerView:self] : [NSColor grayColor];
    button.titleTextHighlightColor = multipleChoiceAnswerDataSourceRespondsTo.textHighlightColorForMultipleChoiceAnswerView ? [self.dataSource textHighlightColorForMultipleChoiceAnswerView:self] : [NSColor whiteColor];
    button.backgroundColor = multipleChoiceAnswerDataSourceRespondsTo.backgroundColorForMultipleChoiceAnswerView ? [self.dataSource backgroundColorForMultipleChoiceAnswerView:self] : [NSColor whiteColor];
    button.backgroundHighlightColor = multipleChoiceAnswerDataSourceRespondsTo.backgroundHighlightColorForMultipleChoiceAnswerView ? [self.dataSource backgroundHighlightColorForMultipleChoiceAnswerView:self] : [NSColor blueColor];
    button.borderColor = multipleChoiceAnswerDataSourceRespondsTo.borderColorForMultipleChoiceAnswerView ? [self.dataSource borderColorForMultipleChoiceAnswerView:self] : [NSColor lightGrayColor];
    button.borderHighlightColor = multipleChoiceAnswerDataSourceRespondsTo.borderHighlightColorForMultipleChoiceAnswerView ? [self.dataSource borderHighlightColorForMultipleChoiceAnswerView:self] : [NSColor grayColor];
    button.textField.stringValue = [self.dataSource multipleChoiceView:self
                                                          titleAtIndex:index];
    NSFont * font = [NSFont fontWithName:@"Helvetica" size:13.0];
    button.textField.font = multipleChoiceAnswerDataSourceRespondsTo.fontForMultipleChoiceAnswerView ? [self.dataSource fontForMultipleChoiceAnswerView:self] : font;
    
    return button;
}

- (void)selectAnswerAction:(id)sender
{
    [self setSelectedIndex:[self.choicesView.subviews indexOfObject:sender]];
}

# pragma mark - Selection

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [self.choicesView.subviews enumerateObjectsUsingBlock:^(TKOMCButton * button, NSUInteger idx, BOOL *stop) {
        button.state = (selectedIndex == idx ? 1 : 0);
    }];
}

- (NSUInteger)selectedIndex
{
    __block NSUInteger selectedIndex = NSNotFound;
    [self.choicesView.subviews enumerateObjectsUsingBlock:^(TKOMCButton * button, NSUInteger idx, BOOL *stop) {
        if (button.state == 1)
        {
            selectedIndex = idx;
            *stop = YES;
        }
    }];
    return selectedIndex;
}

# pragma mark - TKOTabControl Data Source

- (NSUInteger)tabControlNumberOfTabs:(TKOTabControl *)tabControl
{
    return [self.dataSource multipleChoiceViewNumberOfChoices:self];
}

- (NSString *)tabControl:(TKOTabControl *)tabControl
            titleForItem:(id)item
{
    return item;
}

- (id)tabControl:(TKOTabControl *)tabControl
     itemAtIndex:(NSUInteger)index
{
    return [self.dataSource multipleChoiceView:self
                                  titleAtIndex:index];
}

@end

@implementation TKOMCButton
{
    NSInteger _state;
}

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (!self)
        return nil;

    _textField = [NSView viewWithClass:[NSTextField class]];
    _textField.editable        = NO;
    _textField.selectable      = NO;
    _textField.drawsBackground = NO;
    _textField.bezeled         = NO;
    
    [self addSubview:_textField];
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:_textField
                                  attribute:NSLayoutAttributeCenterX
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeCenterX
                                 multiplier:1
                                   constant:0]
     ];
    
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:_textField
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1
                                   constant:0]
     ];

    self.wantsLayer = YES;
    self.layer.borderWidth = 1.5;
    self.layer.cornerRadius = 11.0;

    return self;
}

- (void)setState:(NSInteger)state
{
    _state = state;
    
    self.layer.backgroundColor = _state ? [self.backgroundHighlightColor CGColor] : [self.backgroundColor CGColor];
    self.layer.borderColor     = _state ? [self.borderHighlightColor CGColor] : [self.borderColor CGColor];
    self.textField.textColor   = _state ? self.titleTextHighlightColor : self.titleTextColor;
}

- (NSInteger)state
{
    return _state;
}
@end
