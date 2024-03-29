//
//  TKOTextView.m
//  TextEditor
//
//  Created by Todd Olsen on 7/17/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "TKOTextView.h"
#import "TKOTextStorage.h"
#import "TKOTextContainer.h"
#import "TKOLayoutManager.h"

@implementation TKOTextView

- (id)init
{
    if ( !(self = [super init])) return nil;
    NSLog(@"Error: %s", __PRETTY_FUNCTION__);
    return nil;
}

- (id)initWithFrame:(NSRect)frameRect
{
    if (!(self = [super initWithFrame:frameRect])) return nil;
    NSLog(@"Error: %s", __PRETTY_FUNCTION__);
    return nil;
}

- (id)initWithFrame:(NSRect)frameRect
      textContainer:(NSTextContainer *)container
{
    self = [super initWithFrame:frameRect
                  textContainer:container];
    if (!self)
        return nil;
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
//    [self configureTextView];    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    NSLog(@"Error: %s", __PRETTY_FUNCTION__);
    
    return self;
}

- (void)configureTextView
{
    [self setTextContainerInset:NSMakeSize(20, 20)];
    [self setMinSize:NSMakeSize(0.0, 0.0)];
    [self setMaxSize:NSMakeSize(FLT_MAX, FLT_MAX)];
    [self setVerticallyResizable:YES];
    [self setHorizontallyResizable:YES];
//    [self setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    
    // Behavioral Attributes
    [self setAllowsUndo:YES];
    [self setEditable:YES];
    [self setSelectable:YES];
    [self setRichText:YES];
    [self setImportsGraphics:YES];
    [self setAllowsImageEditing:NO];
    [self setAutomaticQuoteSubstitutionEnabled:YES];
    [self setAutomaticDashSubstitutionEnabled:YES];
    [self setAutomaticSpellingCorrectionEnabled:YES];
    [self setAutomaticTextReplacementEnabled:YES];
    
    // Text Formatting Controls
    [self setUsesRuler:YES];
    [self setRulerVisible:NO];
    [self setUsesInspectorBar:NO];
}

- (void)updateFontPanel
{
    [super updateFontPanel];
    [[NSNotificationCenter defaultCenter] postNotificationName:TKOTextViewDidChangeFontNotification
                                                        object:self];
}

- (BOOL)isOpaque {
    return YES;
}

- (BOOL)isFlipped {
    return YES;
}

@end

NSString * const TKOTextViewDidChangeFontNotification = @"TKOTextViewDidChangeFontNotification";
