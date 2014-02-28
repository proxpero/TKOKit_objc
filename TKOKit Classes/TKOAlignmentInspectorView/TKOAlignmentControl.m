//
//  TKOAlignmentControl.m
//  TKOInspectorViewControllerDemo
//
//  Created by Todd Olsen on 2/23/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOAlignmentControl.h"
#import "NSView+TKOKit.h"

#define CONTROL_TITLE @"Alignment"

@interface TKOAlignmentControl ()

@property (strong, nonatomic) NSTextField        * titleField;
@property (strong, nonatomic) NSSegmentedControl * alignmentControl;
@property (strong, nonatomic) NSSegmentedControl * indentationControl;
@property (strong, nonatomic) NSSegmentedControl * positioningControl;

@end

@implementation TKOAlignmentControl



- (void)configureSubviews
{
    // Configure Title
    
    _titleField = [NSView viewWithClass:[NSTextField class]];
    _titleField.stringValue = CONTROL_TITLE;
    _titleField.font = [NSFont boldSystemFontOfSize:13.0];
    _titleField.textColor = [NSColor darkGrayColor];
    [_titleField invalidateIntrinsicContentSize];
    [_titleField addConstraint:
     [NSLayoutConstraint constraintWithItem:_titleField
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:17]];
    
    // Alignment Control
    
    _alignmentControl = [NSView viewWithClass:[NSSegmentedControl class]];
    _alignmentControl.segmentStyle = NSSegmentStyleRounded;
    [_alignmentControl.cell setTrackingMode:NSSegmentSwitchTrackingSelectOne];
    [_alignmentControl setSegmentCount:4];
    
    // Indentation Control
    
    _indentationControl = [NSView viewWithClass:[NSSegmentedControl class]];
    
    // Positioning Control
    
    _positioningControl = [NSView viewWithClass:[NSSegmentedControl class]];
    
    
}

@end
