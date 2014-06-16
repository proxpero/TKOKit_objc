//
//  TKOProblemEditorPreviewWindowController.m
//  TKOProblemEditorDemo
//
//  Created by Todd Olsen on 6/13/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

@import WebKit;
#import "TKOProblemEditorPreviewWindowController.h"
#import "NSView+TKOKit.h"

static const CGFloat phi = 1.618033988749894848204586834;

@interface TKOProblemEditorPreviewWindowController ()
@property (strong) IBOutlet NSView *documentView;
@property (strong) IBOutlet WebView *webView;

@property (nonatomic) NSString * htmlTemplate;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint * heightConstraint;
//@property (nonatomic) CGFloat currentHeight;

@end

@implementation TKOProblemEditorPreviewWindowController

- (id)init
{
    self = [super initWithWindowNibName:@"TKOProblemEditorPreviewWindowController"];
    if (!self) return nil;
    
    NSURL * url;
    url = [[NSBundle mainBundle] URLForResource:@"TKOHTMLTemplate" withExtension:@"html"];
    _htmlTemplate = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
    url = [[NSBundle mainBundle] URLForResource:@"TKOCSSTemplate" withExtension:@"css"];
    NSString * css = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
    _htmlTemplate = [self.htmlTemplate stringByReplacingOccurrencesOfString:@"{{CSS}}" withString:css];

    return self;
}

- (void)setHtml:(NSString *)html
{
    if ([_html isEqualToString:html]) return;
    _html = html;
    
    if (self.window.isVisible)
        [self loadWebView];
}

- (void)loadWebView
{
    NSString * htmlString = [self.htmlTemplate stringByReplacingOccurrencesOfString:@"{{HTML}}" withString:self.html];
    [self.webView.mainFrame loadHTMLString:htmlString baseURL:nil];
}

- (void)windowDidLoad
{
    NSView * content = self.window.contentView;
    content.wantsLayer = YES;
    content.layer.backgroundColor = [[NSColor lightGrayColor] CGColor];
    
    self.documentView.wantsLayer = YES;
    self.documentView.layer.backgroundColor = [[NSColor whiteColor] CGColor];

    NSShadow * dropShadow = [[NSShadow alloc] init];
    [dropShadow setShadowColor:[NSColor darkGrayColor]];
    [dropShadow setShadowOffset:NSMakeSize(0, -3)];
    [dropShadow setShadowBlurRadius:18.0];
    self.documentView.shadow = dropShadow;

    [self.webView setFrameLoadDelegate:self];
    [[[self.webView mainFrame] frameView] setAllowsScrolling:NO];
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)webFrame
{
    static const CGFloat necessaryOffset = 2; // required for descenders
    static const CGFloat aestheticOffset = 2; // for balancing top margin
    CGFloat compensationOffset = 0;
    
    NSRange range = [self.html rangeOfString:@"$$"];
    if (range.location != NSNotFound)
    {
        compensationOffset = 36;
    }
    
    CGFloat newHeight = [[sender stringByEvaluatingJavaScriptFromString:@"document.body.clientHeight;"] floatValue];
//    CGFloat newHeight = [[sender stringByEvaluatingJavaScriptFromString:@"window.innerHeight;"] floatValue];

    self.heightConstraint.constant = newHeight + necessaryOffset + aestheticOffset + compensationOffset;
}

@end
