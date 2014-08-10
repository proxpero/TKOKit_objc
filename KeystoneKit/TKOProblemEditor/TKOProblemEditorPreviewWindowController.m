//
//  TKOProblemEditorPreviewWindowController.m
//  TKOProblemEditorDemo
//
//  Created by Todd Olsen on 6/13/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

@import WebKit;
@import Quartz;
#import "TKOProblemEditorPreviewWindowController.h"
#import "NSView+TKOKit.h"

@interface TKOProblemEditorPreviewWindowController ()

@property (strong) IBOutlet NSView *documentView;
@property (strong) IBOutlet WebView *webView;
@property (nonatomic) NSString * htmlTemplate;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint * heightConstraint;
@property (strong) IBOutlet PDFView *pdfView;

@property (nonatomic) NSURL * htmlUrl;

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
    NSURL * baseURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDesktopDirectory inDomains:NSUserDomainMask] firstObject];
    NSString * htmlString = [self.htmlTemplate stringByReplacingOccurrencesOfString:@"{{HTML}}" withString:self.html];
    [self.webView.mainFrame loadHTMLString:htmlString baseURL:baseURL];
    
    NSURL * url = [[[NSFileManager defaultManager] URLsForDirectory:NSDesktopDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"Test.html"];
    [htmlString writeToURL:url atomically:YES encoding:NSUTF8StringEncoding error:NULL];
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
    NSLog(@"first height %f", [[sender stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue]);
    [self performSelector:@selector(waitForMathjax:) withObject:sender afterDelay:1.0];
    NSLog(@"second height %f", [[sender stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue]);
}

- (void)waitForMathjax:(WebView *)webView
{
    static const CGFloat necessaryOffset = 2; // required for descenders
    static const CGFloat aestheticOffset = 2; // for balancing top margin
    
    CGFloat newHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    NSLog(@"third height %f", newHeight);
    self.heightConstraint.constant = newHeight + necessaryOffset + aestheticOffset;
    [self performSelector:@selector(makePdf) withObject:nil afterDelay:1.0];
}

- (void)makePdf
{
    PDFDocument * pdfDoc = [[PDFDocument alloc] initWithData:[self.webView dataWithPDFInsideRect:self.webView.bounds]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL * pdfURL = [[fileManager URLsForDirectory:NSDesktopDirectory inDomains:NSUserDomainMask] lastObject];
    pdfURL = [pdfURL URLByAppendingPathComponent:@"Test.pdf"];
    
    [self.pdfView  setDocument:pdfDoc];
    [pdfDoc writeToURL:pdfURL];
    
//    NSLog(@"%@", self.html);
}

@end
