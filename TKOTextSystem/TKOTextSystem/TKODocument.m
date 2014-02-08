//
//  TKODocument.m
//  TKOTextSystem
//
//  Created by Todd Olsen on 2/7/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKODocument.h"
#import "TKOTextView.h"
#import "TKOTextStorage.h"
#import "TKOTextContainer.h"
#import "TKOLayoutManager.h"

@interface TKODocument ()

@property (weak) IBOutlet NSScrollView *scrollView;
@property (unsafe_unretained, nonatomic) TKOTextView * textView;

@property (strong, nonatomic) TKOTextStorage * textStorage;

@end

@implementation TKODocument

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

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    [self setupTextSystem];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName
                 error:(NSError **)outError
{
    NSAttributedString * string = [self.textView.textStorage attributedSubstringFromRange:NSMakeRange(0, self.textView.textStorage.length)];
    NSLog(@"write string %@", string.string);
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:string];
    return data;
}

- (BOOL)readFromData:(NSData *)data
              ofType:(NSString *)typeName
               error:(NSError **)outError
{
    NSAttributedString * string = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"read string %@", string.string);
    if (string) {
        [self.textStorage setAttributedString:string];
        return YES;
    }
    return NO;
}

- (void)setupTextSystem
{
    NSLayoutManager * layoutManager = [[NSLayoutManager alloc] init];
    [self.textStorage addLayoutManager:layoutManager];
    
    TKOTextContainer * textContainer = [[TKOTextContainer alloc] init];
    [layoutManager addTextContainer:textContainer];
    TKOTextView * textView = [[TKOTextView alloc] initWithFrame:NSZeroRect
                                                  textContainer:textContainer];
//    [textView setDelegate:self.inspectorViewController];
    
    [textView setTextContainerInset:NSMakeSize(20, 20)];
    [self.scrollView setDocumentView:textView];
//    [self.inspectorViewController setTextView:textView];
//    [textView setSelectedRanges:initialSelctedRanges];
}

@end
