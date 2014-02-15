
/*
     File: TKOScalingScrollView.h
 {
     Abstract: NSScrollView subclass to support scaling content.
      Version: 1.9
     Copyright (C) 2013 Apple Inc. All Rights Reserved.
 }
 
 Originally from Apple's TextEdit app. Modified by TKO.
 
 */

#import <Cocoa/Cocoa.h>

@class NSPopUpButton;

@interface TKOScalingScrollView : NSScrollView

@property (nonatomic) BOOL fitToWidth;
@property (nonatomic) CGFloat documentWidth;
@property (nonatomic) CGFloat documentInset;

//- (void)setScaleFactor:(CGFloat)factor
//           adjustPopup:(BOOL)flag;

//- (CGFloat)scaleFactor;

- (void)frameDidChange:(NSNotification *)notification;

//- (IBAction)zoomToActualSize:(id)sender;
//- (IBAction)zoomIn:(id)sender;
//- (IBAction)zoomOut:(id)sender;

@end

