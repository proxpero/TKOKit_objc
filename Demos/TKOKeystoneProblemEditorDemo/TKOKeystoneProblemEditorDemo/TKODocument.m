//
//  TKODocument.m
//  TKOKeystoneProblemEditorDemo
//
//  Created by Todd Olsen on 3/18/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKODocument.h"
#import "TKOTextSystem.h"
#import "TKOScalingScrollView.h"

#import "TKOTabView.h"
#import "TKOTemplateViewController.h"
#import "TKOFirstViewController.h"
#import "TKOSecondViewController.h"

@interface TKODocument () <TKOTabViewDelegate>

@property (strong, nonatomic) TKOTextView        * textView;
@property (strong, nonatomic) TKOTextStorage     * textStorage;
@property (strong) IBOutlet TKOScalingScrollView *textScrollView;

@property (strong) IBOutlet TKOTabView *tabView;
@property (strong, nonatomic) TKOTemplateViewController * templateViewController;
@property (strong) TKOFirstViewController * vc1;
@property (strong) TKOSecondViewController * vc2;

@end

@implementation TKODocument

- (void)tabViewSelectionDidChange:(NSNotification *)notification
{
    id <NSTextViewDelegate, NSTextStorageDelegate> selection = self.tabView.selectedItem;
    [self.textStorage setDelegate:selection];
    [self.textView setDelegate:selection];
}

- (void)setupTextSystem
{
    if (!self.textScrollView)
        return;
    
    CGFloat docWidth = 340.0;
    CGFloat docInset = 40.0;
    
    NSLayoutManager * layoutManager = [[NSLayoutManager alloc] init];
    [self.textStorage addLayoutManager:layoutManager];
    TKOTextContainer * textContainer = [[TKOTextContainer alloc] init];
    [textContainer setContainerSize:NSMakeSize(docWidth, FLT_MAX)];
    [textContainer setWidthTracksTextView:YES];
    [layoutManager addTextContainer:textContainer];
    
    NSRect frameRect = NSMakeRect(0, 0, docWidth, 1); // Using FLT_MAX or CGFloat_Max for frameRect height caused <Error>: CGAffineTransformInvert: singular matrix. See also Peter Hosey's comment: http://stackoverflow.com/questions/7471027/overriding-layoutsubviews-causes-cgaffinetransforminvert-singular-matrix-ran#comment23126967_7471027
    
    self.textView = [[TKOTextView alloc] initWithFrame:frameRect
                                                  textContainer:textContainer];
    [self.textView setHorizontallyResizable:NO];
    [self.textView setAutoresizingMask:NSViewHeightSizable];

    [self.textScrollView setDocumentWidth:docWidth];
    [self.textScrollView setDocumentInset:docInset];
    [self.textScrollView setDocumentView:self.textView];
    [self.textView setTextContainerInset:NSMakeSize(docInset, docInset)]; // I put this (textView setTextContainerInset:) here because when I put it after the textView alloc/init a strange bug caused the tv frame to sharply decrease.
    [self.textScrollView setFitToWidth:YES];
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    
    [self setupTextSystem];
    
    self.templateViewController = [[TKOTemplateViewController alloc] init];
    self.templateViewController.textView = self.textView;
    
    self.vc1 = [[TKOFirstViewController alloc] init];
    self.vc2 = [[TKOSecondViewController alloc] init];

    [self.tabView setDelegate:self];
    [self.tabView setTabViewItems:@[self.templateViewController, self.vc1, self.vc2]];
    [self.tabView setSelectedItem:self.templateViewController];
}

- (id)init
{
    self = [super init];
    if (!self)
        return nil;

    _textStorage = [[TKOTextStorage alloc] init];
    
    return self;
}

- (NSString *)windowNibName
{
    return @"TKODocument";
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName
                 error:(NSError **)outError
{
    NSAttributedString * string = [self.textStorage attributedSubstringFromRange:NSMakeRange(0, self.textStorage.length)];
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:string];
    return data;
}

- (BOOL)readFromData:(NSData *)data
              ofType:(NSString *)typeName
               error:(NSError **)outError
{
    NSAttributedString * string = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (string) {
        [self.textStorage setAttributedString:string];
        return YES;
    }
    return NO;
}

@end