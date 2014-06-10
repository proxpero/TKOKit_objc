//
//  TKOProblemEditorTextComponentView.m
//  ProblemEditor
//
//  Created by Todd Olsen on 6/6/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOProblemEditorTextComponentView.h"
#import "TKOProblemEditorTextView.h"
#import "NSView+TKOKit.h"

@interface TKOProblemEditorTextComponentView () <TKOProblemEditorTextKeyInterceptionDelegate>

@property (nonatomic, readwrite) TKOProblemEditorTextView * textView;

@end

@implementation TKOProblemEditorTextComponentView

- (instancetype)initWithFont:(NSFont *)font placeholder:(NSString *)placeholder
{
    self = [super initWithFrame:NSZeroRect];
    if (!self) return nil;
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    _textView = [[TKOProblemEditorTextView alloc] initWithFont:font
                                                   placeholder:placeholder
                                                     textInset:NSZeroSize];
    _textView.delegate = self;
    [self addSubviewWithFullSizeConstraints:_textView];
    
    return self;
}

# pragma mark - Keyboard Actions

//- (void)keyDown:(NSEvent *)theEvent
//{
//    NSUInteger keyCode = theEvent.keyCode;
//    NSRange selectedRange = self.selectedRange;
//    BOOL isAtFirstPosition = NSEqualRanges(selectedRange, NSMakeRange(0, 0));
//    BOOL isAtLastPosition = NSEqualRanges(selectedRange, NSMakeRange(self.string.length, 0));
//    
//    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
//    
//    if ((keyCode == 124 && isAtLastPosition) || (keyCode == 125 && isAtLastPosition))
//    {
//        //        [center postNotificationName:TKOTextGoForwardKeyNotification object:self];
//        id <TKOProblemEditorTextKeyInterceptionDelegate> d = (id <TKOProblemEditorTextKeyInterceptionDelegate>)self.delegate;
//        [d textViewDidForward:nil];
//    }
//    else if ((keyCode == 123 && isAtFirstPosition) || (keyCode == 126 && isAtFirstPosition))
//        [center postNotificationName:TKOTextGoBackwardKeyNotification object:self];
//    else if (keyCode == 48)
//        [center postNotificationName:TKOTextTabKeyNotification object:self];
//    else if (keyCode == 36)
//        [center postNotificationName:TKOTextNewlineKeyNotification object:self];
//    else if (keyCode == 51 && self.string.length == 0)
//        [center postNotificationName:TKOTextDeleteKeyNotification object:self];
//    else
//        [[self nextResponder] keyDown:theEvent];
//}

- (void)goForwardAction:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)goBackwardAction:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)newlineAction:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)tabAction:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)deleteAction:(id)sender
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
