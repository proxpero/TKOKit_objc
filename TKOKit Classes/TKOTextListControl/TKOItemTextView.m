//
//  TKOItemTextView.m
//  TKOTextItemViewDemo
//
//  Created by Todd Olsen on 6/5/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOItemTextView.h"
#import "TKOTextListItem.h"
#import "TKOProblemEditorTextView.h"

@interface TKOItemTextView ()

@property (nonatomic) TKOProblemEditorTextView * textView;

@end

@implementation TKOItemTextView

- (void)keyDown:(NSEvent *)theEvent
{
    static unsigned short newlineCode = 36;
    static unsigned short tabCode = 48;
    static unsigned short deleteCode = 51;
    static unsigned short leftArrowCode = 123;
    static unsigned short rightArrowCode = 124;
    static unsigned short downArrowCode = 125;
    static unsigned short upArrowCode = 126;
    
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    TKOTextListItem * parent = (TKOTextListItem *)[self superview];
    
    NSRange selectedRange = self.textView.selectedRange;
    BOOL isAtFirstPosition = NSEqualRanges(selectedRange, NSMakeRange(0, 0));
    BOOL isAtLastPosition = NSEqualRanges(selectedRange, NSMakeRange(self.textView.string.length, 0));
    
    BOOL advance = (isAtLastPosition && theEvent.keyCode == rightArrowCode) || (isAtLastPosition && theEvent.keyCode == downArrowCode) || theEvent.keyCode == tabCode;
    BOOL recede = (isAtFirstPosition && (theEvent.keyCode == upArrowCode || theEvent.keyCode == leftArrowCode));
    BOOL delete = (self.textView.string.length == 0) && (theEvent.keyCode == deleteCode);
    
    if (theEvent.keyCode == newlineCode) {
        [center postNotificationName:TKOTextListItemWantsNewSiblingNotification object:parent];
    } else if (advance) {
        [center postNotificationName:TKOTextListItemWantsAdvancementNotification object:parent];
    } else if (recede) {
        [center postNotificationName:TKOTextListItemWantsPreviousNotification object:parent];
    } else if (delete) {
        [center postNotificationName:TKODeleteTextListItemNotification object:parent];
    }
    else [super keyDown:theEvent];
}

//- (void)drawRect:(NSRect)dirtyRect
//{
//    [super drawRect:dirtyRect];
//    
//    BOOL isEmpty = [[self.textView string] isEqualToString:@""];
//    BOOL isNotFirst = self != [[self window] firstResponder];
//
//    if (isEmpty && isNotFirst)
//        [self.placeholder drawAtPoint:NSMakePoint(12, 1)];
//}

//- (BOOL)becomeFirstResponder
//{
//    [self setNeedsDisplay:YES];
//    return [super becomeFirstResponder];
//}

//- (BOOL)resignFirstResponder
//{
//    [self setSelectedRange:NSMakeRange(0, 0)];
//    [self setNeedsDisplay:YES];
//    return [super resignFirstResponder];
//}

@end