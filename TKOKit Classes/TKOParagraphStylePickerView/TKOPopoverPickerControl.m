//
//  TKOPopoverPickerControl.m
//  TKOInspectorViewControllerDemo
//
//  Created by Todd Olsen on 2/20/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOPopoverPickerControl.h"
#import "TKOHeaderCell.h"
#import "TKOTextView.h"

#import "TKOParagraphStylePickerPopoverContentViewController.h"

@interface TKOPopoverPickerCell : TKOHeaderCell
@property (strong, nonatomic) NSDictionary * titleAttributes;
@end

@interface TKOPopoverPickerControl () <NSPopoverDelegate>

@property (strong, nonatomic) NSPopover * popover;

@end

@implementation TKOPopoverPickerControl

+ (Class)cellClass
{
    return [TKOPopoverPickerCell class];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (!self)
        return nil;
    
    [self configurePicker];
    [self configurePopover];
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configurePicker];
    [self configurePopover];
}

- (void)configurePicker
{
    [self setTarget:self];
    [self setAction:@selector(selectParagraphStyleAction:)];
}

- (void)configurePopover
{
    if (self.popover)
        return;
    self.popover = [[NSPopover alloc] init];
    [self.popover setBehavior:NSPopoverBehaviorTransient];
    [self.popover setDelegate:self];
    [self.popover setContentViewController:[[TKOParagraphStylePickerPopoverContentViewController alloc] init]];
}

- (void)setTextView:(TKOTextView *)textView
{
    if (_textView == textView)
        return;
    
    NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter removeObserver:self
                             name:NSTextViewDidChangeSelectionNotification
                           object:_textView];
    
    _textView = textView;
    
    [defaultCenter addObserver:self
                      selector:@selector(textViewDidChangeParagraphStyle:)
                          name:NSTextViewDidChangeSelectionNotification
                        object:_textView];
    
}

- (void)textViewDidChangeParagraphStyle:(NSNotification *)notification
{
    NSArray * ranges = self.textView.selectedRanges;
    for (NSValue * value in ranges) {
        NSRange range = [value rangeValue];
        if (range.location < self.textView.string.length)
        {
            NSMutableDictionary * attributes = [NSMutableDictionary new];
            [attributes setObject:[self.textView.textStorage attribute:NSFontAttributeName
                                                               atIndex:range.location
                                                        effectiveRange:NULL]
                           forKey:NSFontAttributeName];
            [self.cell setTitleAttributes:attributes];
        }
    }
    [self setNeedsDisplay];
}

- (void)selectParagraphStyleAction:(id)sender
{
    [self.popover showRelativeToRect:[sender bounds]
                              ofView:sender
                       preferredEdge:NSMinYEdge];
}

- (void)popoverDidClose:(NSNotification *)notification
{
    [self.cell setState:NSOffState];
}

@end

@implementation TKOPopoverPickerCell

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    [self setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Picker"]];
    [self setBorderMask:TKOBorderMaskBottom];
    [self setBackgroundColor:[NSColor whiteColor]];
//    [self setBorderHighlightColor:self.borderColor];
    
    return self;
}

- (NSRect)popupRectWithFrame:(NSRect)cellFrame
{
    NSRect popupRect = NSZeroRect;
    popupRect.size = [[TKOHeaderCell popupImage] size];
    popupRect.origin = NSMakePoint(NSMaxX(cellFrame) - NSWidth(popupRect) - 20, NSMidY(cellFrame) - NSHeight(popupRect) / 2);
    
    return popupRect;
}

- (void)drawWithFrame:(NSRect)cellFrame
               inView:(NSView *)controlView
{
    [self.backgroundColor set];
    NSRectFill(cellFrame);
    
    [[TKOHeaderCell popupImage] drawInRect:[self popupRectWithFrame:cellFrame]
                                  fromRect:NSZeroRect
                                 operation:NSCompositeSourceOver
                                  fraction:1.0
                            respectFlipped:YES
                                     hints:nil];
    
    NSMutableAttributedString * attributedTitle = self.attributedTitle.mutableCopy;
    if (self.titleAttributes)
    {
        [attributedTitle addAttributes:self.titleAttributes
                                 range:NSMakeRange(0, attributedTitle.length)];
    }
    
    [self drawTitle:attributedTitle
          withFrame:NSOffsetRect(cellFrame, 20, 0)
             inView:controlView];
    
    [self drawBordersInCellFrame:cellFrame];
}

@end