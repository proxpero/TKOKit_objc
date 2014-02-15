
/*
     File: TKOScalingScrollView.m
 {
     Abstract: NSScrollView subclass to support scaling content.
     Version: 1.9
     Copyright (C) 2013 Apple Inc. All Rights Reserved.
 }
 
 Originally from Apple's TextEdit app. Modified by TKO.
 
 */

#import <Cocoa/Cocoa.h>
#import "TKOScalingScrollView.h"

@implementation TKOScalingScrollView

//- (void)awakeFromNib
//{
//    [super awakeFromNib];
//    [self setAllowsMagnification:YES];
//    [self setMaxMagnification:16.0];
//    [self setMinMagnification:0.25];
//}

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

//- (CGFloat)scaleFactor
//{
//    return [self magnification];
//}
//
//- (void)setScaleFactor:(CGFloat)newScaleFactor
//{
//    [self setMagnification:newScaleFactor];
//}
//
//- (void)setScaleFactor:(CGFloat)newScaleFactor
//           adjustPopup:(BOOL)flag
//{
//    [self setScaleFactor:newScaleFactor];
//}

    /* Action methods */

//- (IBAction)zoomToActualSize:(id)sender
//{
//    [[self animator] setMagnification:1.0];
//}

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
    
//    NSTextView * tv = self.documentView;
//    NSLog(@"tv class: %@", NSStringFromClass([tv class]));
//    
//    NSLog(@"textviewrect 10 %@", NSStringFromRect([tv frame]));
    
    NSRect visibleRect = [self documentVisibleRect];
    
    CGFloat scaleFactor = (NSWidth(visibleRect) - (1 * self.documentInset))/self.documentWidth;
//    NSLog(@"scaleFactor %f", scaleFactor);
    NSRect scaledVisibleRect = NSMakeRect(
                                   visibleRect.origin.x,
                                   visibleRect.origin.y,
                                   visibleRect.size.width * scaleFactor,
                                   visibleRect.size.height * scaleFactor
                                );
    NSRect originalDocumentViewFrame = [self.documentView frame];
//    NSLog(@"textviewrect 11 %@", NSStringFromRect([tv frame]));

    
//    if (NSWidth(originalDocumentViewFrame) < NSWidth(visibleRect)) {
//        [self.documentView setFrame:NSMakeRect(
//                                               visibleRect.origin.x,
//                                               visibleRect.origin.y,
//                                               visibleRect.size.width,
//                                               newHeight
//                                               )];
//        NSLog(@"adjusting original rect");
//        return;
//    }
    
    [self.documentView scaleUnitSquareToSize:NSMakeSize(scaleFactor, scaleFactor)];
//    NSLog(@"textviewrect 12 %@", NSStringFromRect([tv frame]));

    [self.documentView setFrame:NSMakeRect(
                                           originalDocumentViewFrame.origin.x,
                                           originalDocumentViewFrame.origin.y,
                                           originalDocumentViewFrame.size.width * scaleFactor,
                                           originalDocumentViewFrame.size.height * scaleFactor
                                           )];
//    NSLog(@"textviewrect 13 %@", NSStringFromRect([tv frame]));

//    NSLog(@"\n\nvisibleRect %@, \nscaledVisibleRect %@, \noriginalDocumentViewFrame %@, \nself.documentView.frame %@\n", NSStringFromRect(visibleRect), NSStringFromRect(scaledVisibleRect), NSStringFromRect(originalDocumentViewFrame), NSStringFromRect([self.documentView frame]));
    
    CGPoint scrollPoint = NSMakePoint(scaledVisibleRect.origin.x, scaledVisibleRect.origin.y - self.documentInset * scaleFactor);
    [[self documentView] scrollPoint:scrollPoint];
}

//- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
//{
//    switch (menuItem.tag) {
//        case 667:
//        case 668:
//        case 669:
//        case 670:
//        case 671:
//            return YES;
//            break;
//            
//        default:
//            return NO;
//            break;
//    }
//}

//- (IBAction)zoomIn:(id)sender
//{
//    CGFloat scaleFactor = [self scaleFactor];
//    scaleFactor = (scaleFactor > 0.4 && scaleFactor < 0.6) ? 1.0 : scaleFactor * 2.0;
//    [[self animator] setMagnification:scaleFactor];
//}
//
//- (IBAction)zoomOut:(id)sender
//{
//    CGFloat scaleFactor = [self scaleFactor];
//    scaleFactor = (scaleFactor > 1.8 && scaleFactor < 2.2) ? 1.0 : scaleFactor / 2.0;
//    [[self animator] setMagnification:scaleFactor];
//}

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
