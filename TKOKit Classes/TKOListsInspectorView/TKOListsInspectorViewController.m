//
//  TKOListsInspectorViewController.m
//  TKOListAndBulletsInspectorDemo
//
//  Created by Todd Olsen on 2/14/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOListsInspectorViewController.h"

@interface TKOListsInspectorViewController ()

@end

NSString * listTitle = @"Bullets & Lists";
NSString * listNibName = @"TKOListsInspectorViewController";
NSString * listViewID = @"TKOListContentViewIdentifier";

@implementation TKOListsInspectorViewController

# pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    NSNib * nib = [[NSNib alloc] initWithNibNamed:listNibName
                                           bundle:nil];
    [self setTitle:listTitle];
    NSArray * topLevelObjects;
    [nib instantiateWithOwner:self
              topLevelObjects:&topLevelObjects];
    
    for (id object in topLevelObjects) {
        if ([object isKindOfClass:[NSView class]] && [[object identifier] isEqualToString:listViewID])
            [self setContentView:object];
    }
    
    return self;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateListAttributes:)
                                                 name:NSTextViewDidChangeSelectionNotification
                                               object:_textView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateListAttributes:(NSNotification *)notification
{
    
}

@end
