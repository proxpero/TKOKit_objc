//
//  TKODocument.m
//  TKOResponsiveTextFrameDemo
//
//  Created by Todd Olsen on 2/14/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKODocument.h"
#import "TKOTextSystem.h"
#import "TKOScalingScrollView.h"

@interface TKODocument () <NSTextViewDelegate>

@property (strong, nonatomic) TKOTextStorage * textStorage;
@property (weak) IBOutlet TKOScalingScrollView *textScrollView;

@end

@implementation TKODocument



- (void)setupTextSystem
{
    NSLayoutManager * layoutManager = [[NSLayoutManager alloc] init];
    [self.textStorage addLayoutManager:layoutManager];
    TKOTextContainer * textContainer = [[TKOTextContainer alloc] init];
    CGFloat docWidth = 380.0;
    CGFloat docInset = 40.0;
    [textContainer setContainerSize:NSMakeSize(docWidth, FLT_MAX)];
    [textContainer setWidthTracksTextView:YES];
    [layoutManager addTextContainer:textContainer];
    TKOTextView * textView = [[TKOTextView alloc] initWithFrame:NSMakeRect(0, 0, docWidth, FLT_MAX)
                                                  textContainer:textContainer];
    [textView setHorizontallyResizable:NO];
    [textView setAutoresizingMask:NSViewHeightSizable];
    [self.textScrollView setDocumentWidth:docWidth];
    [self.textScrollView setDocumentInset:docInset];
    [self.textScrollView setDocumentView:textView];
    [textView setTextContainerInset:NSMakeSize(docInset, docInset)]; // I put this here because when I put it
                                                                     // after the textView alloc/init a strange
                                                                     // bug caused the tv frame to sharply decrease.
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
    if (![self.textScrollView.documentView isKindOfClass:[TKOTextView class]]) // && NSWidth([self.textScrollView.documentView frame]) < 91)
        [self setupTextSystem];
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
