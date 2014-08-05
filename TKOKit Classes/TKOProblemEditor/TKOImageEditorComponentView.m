//
//  TKOImageEditorComponentView.m
//  TKOProblemEditorDemo
//
//  Created by Todd Olsen on 6/22/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOImageEditorComponentView.h"
#import "NSView+TKOKit.h"
#import "TKOThemeLoader.h"
#import "TKOTheme.h"

@interface TKOImageEditorComponentView ()

@property (nonatomic) NSImageView * imageView;
@property (nonatomic, strong) NSLayoutConstraint * heightConstraint;
@property (nonatomic) NSURL * imageUrl;
@property (nonatomic) NSString * filename;
@end

@implementation TKOImageEditorComponentView

- (id)init
{
    self = [super initWithFrame:NSZeroRect];
    if (!self) return nil;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
//    TKOThemeLoader * themeLoader = [[TKOThemeLoader alloc] init];
//    TKOTheme * theme = themeLoader.defaultTheme;
    
    _imageUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDesktopDirectory inDomains:NSUserDomainMask] lastObject];
    _filename = [NSString stringWithFormat:@"%@.pdf", [[NSUUID UUID] UUIDString]];
    _imageUrl = [_imageUrl URLByAppendingPathComponent:_filename];
    _imageView = [[NSImageView alloc] initWithFrame:NSZeroRect];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    _imageView.focusRingType = NSFocusRingTypeNone;
    _imageView.imageAlignment = NSImageAlignCenter;
//    _imageView.imageFrameStyle = NSImageFrameGroove;
    _imageView.imageScaling = NSImageScaleNone;
    _imageView.editable = YES;
    _imageView.wantsLayer = YES;
    _imageView.layer.backgroundColor = [[NSColor whiteColor] CGColor];
    
    [self addSubviewWithFullSizeConstraints:_imageView];
    
    _heightConstraint = [NSLayoutConstraint constraintWithItem:_imageView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1
                                                      constant:50];
    [self addConstraint:_heightConstraint];
    [_imageView addObserver:self forKeyPath:@"image" options:0 context:NULL];
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    [self performSelector:@selector(delayme) withObject:nil afterDelay:2.0];
}

- (void)delayme
{
    NSSize size = self.imageView.image.size;
    NSPoint origin = NSMakePoint(NSWidth(self.bounds)/2 - size.width/2, 0);
    CGFloat constant = size.height;
    NSLog(@"orig height: %@", @(constant));
    
    if (constant < 10) constant = 10;
    if (!self.imageView.image) constant = 50;
    self.heightConstraint.constant = constant;
    NSLog(@"image view bounds: %@", NSStringFromRect(self.imageView.bounds));
    NSLog(@"image view frame: %@", NSStringFromRect(self.imageView.frame));
    NSLog(@"self.bounds: %@", NSStringFromRect(self.bounds));
    NSLog(@"self.frame: %@", NSStringFromRect(self.frame));
    NSData * data = [self dataWithPDFInsideRect:NSMakeRect(origin.x, 0, size.width, size.height)];
    [data writeToURL:self.imageUrl atomically:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:TKOComponentDidUpdateHtmlNotification object:self];
    
}

- (NSString *)title
{
    return @"Image";
}

- (NSView *)firstKeyView
{
    return self.imageView;
}

- (NSView *)lastKeyView
{
    return self.imageView;
}

- (NSString *)html
{
    NSSize size = self.imageView.image.size;
    NSString * html = [NSString stringWithFormat:@"<img src='%@' height='%d' width='%d'>", self.filename, (int)size.height, (int)size.width];
//    return [NSString stringWithFormat:@"<img src='%@'>", self.filename];
    return html;
}

@end
