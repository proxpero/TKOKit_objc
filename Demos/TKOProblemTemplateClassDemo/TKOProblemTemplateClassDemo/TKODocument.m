//
//  TKODocument.m
//  TKOProblemTemplateClassDemo
//
//  Created by Todd Olsen on 3/5/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKODocument.h"
#import "TKOTextSystem.h"
#import "TKODisclosingView.h"

@interface TKODocument () <NSTextViewDelegate>

@property (strong, nonatomic) TKOTextStorage * textStorage;
@property (weak) IBOutlet NSScrollView *textScrollView;

@property (weak) IBOutlet NSStackView *stackView;
@property (strong, nonatomic) TKODisclosingView *disclosingView;

@property (strong) IBOutlet NSView *testView;

@end

@implementation TKODocument

- (void)setupTextSystem
{
    NSLayoutManager * layoutManager = [[NSLayoutManager alloc] init];
    [self.textStorage addLayoutManager:layoutManager];
    
    TKOTextContainer * textContainer = [[TKOTextContainer alloc] init];
    [layoutManager addTextContainer:textContainer];
    TKOTextView * textView = [[TKOTextView alloc] initWithFrame:NSZeroRect
                                                  textContainer:textContainer];
    
    [textView setTextContainerInset:NSMakeSize(20, 20)];
//    [[NSNotificationCenter defaultCenter] addObserver:self.listInspector
//                                             selector:@selector(updateListAttributes:)
//                                                 name:NSTextViewDidChangeSelectionNotification
//                                               object:textView];
    [self.textScrollView setDocumentView:textView];
//    [self.listInspector setTextView:textView];
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
    self.disclosingView = [[TKODisclosingView alloc] initWithTitle:@"Discloser"
                                                       contentView:self.testView];
    [self.disclosingView addConstraint:
     [NSLayoutConstraint constraintWithItem:self.disclosingView
                                  attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:1
                                   constant:self.stackView.bounds.size.width]
     ];
    
    [self.stackView addView:self.disclosingView
                  inGravity:NSStackViewGravityTop];

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
