//
//  TKOScalingScrollView.m
//  TKOKit
//
//  Created by Todd Olsen on 2/15/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TKOScalingScrollView.h"

@implementation TKOScalingScrollView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setAllowsMagnification:YES];
    [self setMaxMagnification:16.0];
    [self setMinMagnification:0.25];
}

- (void)setFitToWidth:(BOOL)fitToWidth
{
    if (_fitToWidth == fitToWidth)
        return;
    
    _fitToWidth = fitToWidth;
    
    if (_fitToWidth) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(frameDidChange:)
                                                     name:NSViewFrameDidChangeNotification
                                                   object:self];
        [self zoomToFitWidth];
        
    } else {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:NSViewFrameDidChangeNotification
                                                      object:self];
    }
}

- (void)frameDidChange:(NSNotification *)notification
{
    if (self != [notification object])
        return;
    [self zoomToFitWidth];
}

- (void)zoomToFitWidth
{
    if (self.documentWidth <= 0) {
        NSLog(@"zero width");
        return;
    }

    NSRect visibleRect = [self documentVisibleRect];
    
    CGFloat scaleFactor = (NSWidth(visibleRect) - (1 * self.documentInset))/self.documentWidth;
    NSRect scaledVisibleRect = NSMakeRect(
                                   visibleRect.origin.x,
                                   visibleRect.origin.y,
                                   visibleRect.size.width * scaleFactor,
                                   visibleRect.size.height * scaleFactor
                                );
    NSRect originalDocumentViewFrame = [self.documentView frame];
    [self.documentView scaleUnitSquareToSize:NSMakeSize(scaleFactor, scaleFactor)];
    [self.documentView setFrame:NSMakeRect(
                                           originalDocumentViewFrame.origin.x,
                                           originalDocumentViewFrame.origin.y,
                                           originalDocumentViewFrame.size.width * scaleFactor,
                                           originalDocumentViewFrame.size.height * scaleFactor
                                           )];
    
    CGPoint scrollPoint = NSMakePoint(scaledVisibleRect.origin.x, scaledVisibleRect.origin.y - self.documentInset * scaleFactor);
    [[self documentView] scrollPoint:scrollPoint];
}

/* 
    Reassure AppKit that TKOScalingScrollView supports live resize content
    preservation, even though it's a subclass that could have modified 
    NSScrollView in such a way as to make NSScrollView's live resize
    content preservation support inoperative. By default this is disabled 
    for NSScrollView subclasses.
*/

- (BOOL)preservesContentDuringLiveResize
{
    return [self drawsBackground];
}

@end
