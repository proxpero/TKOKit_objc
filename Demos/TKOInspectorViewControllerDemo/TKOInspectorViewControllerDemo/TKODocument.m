//
//  TKODocument.m
//  TKOInspectorViewControllerDemo
//
//  Created by Todd Olsen on 2/18/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKODocument.h"
#import "TKOTabView.h"
#import "TKOTextSystem.h"
#import "TKOScalingScrollView.h"

#import "TKOTextInspectorViewController.h"


@interface TKODocument ()

@property (weak) IBOutlet TKOTabView *tabView;

@property (strong, nonatomic) TKOTextStorage * textStorage;
@property (weak) IBOutlet TKOScalingScrollView * textScrollView;

@property (strong, nonatomic) TKOTextInspectorViewController * textInspector;

@end


@implementation TKODocument

- (void)setupTabView
{
    self.textInspector = [[TKOTextInspectorViewController alloc] initWithTextView:self.textScrollView.documentView];
    [self.tabView setTabViewItems:@[
                                   [TKOTabViewItem itemWithView:self.textInspector.view
                                                          title:self.textInspector.title]
                                   ]];
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
    
    NSRect frameRect = NSMakeRect(0, 0, docWidth, 1); // Using FLT_MAX or CGFloat_Max for frameRect height caused <Error>: CGAffineTransformInvert: singular matrix. See Peter Hosey's comment: http://stackoverflow.com/questions/7471027/overriding-layoutsubviews-causes-cgaffinetransforminvert-singular-matrix-ran#comment23126967_7471027
    
    TKOTextView * textView = [[TKOTextView alloc] initWithFrame:frameRect
                                                  textContainer:textContainer];
    [textView setHorizontallyResizable:NO];
    [textView setAutoresizingMask:NSViewHeightSizable];

    [self.textScrollView setDocumentWidth:docWidth];
    [self.textScrollView setDocumentInset:docInset];
    [self.textScrollView setDocumentView:textView];
    [textView setTextContainerInset:NSMakeSize(docInset, docInset)]; // I put this (textView setTextContainerInset:) here because when I put it after the textView alloc/init a strange bug caused the tv frame to sharply decrease.
    [self.textScrollView setFitToWidth:YES];
}

- (id)init
{
    self = [super init];
    if (self) {
        _textStorage = [[TKOTextStorage alloc] init];
    }
    return self;
}

- (NSString *)windowNibName
{
    return @"TKODocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];

    [self setupTextSystem];
    [self setupTabView];
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
