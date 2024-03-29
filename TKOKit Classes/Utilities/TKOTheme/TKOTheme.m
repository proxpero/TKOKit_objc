//
//  TKOTheme.m
//
//  Originally Created by Brent Simmons on 6/26/13.
//  Copyright (c) 2012 Q Branch LLC. All rights reserved.
//
//  Modified by TKO
//

#import "TKOTheme.h"
#import "NSString+TKOKit.h"

static BOOL stringIsEmpty(NSString *s);
static TKO_COLOR *colorWithHexString(NSString *hexString);


@interface TKOTheme ()

@property (nonatomic, strong) NSDictionary *themeDictionary;
@property (nonatomic, strong) NSCache *colorCache;
@property (nonatomic, strong) NSCache *fontCache;
@property (nonatomic) NSCache * gradientCache;

@end


@implementation TKOTheme


#pragma mark Init

- (id)initWithDictionary:(NSDictionary *)themeDictionary {
	
	self = [super init];
	if (self == nil)
		return nil;
	
	_themeDictionary = themeDictionary;

	_colorCache = [NSCache new];
	_fontCache = [NSCache new];

	return self;
}


- (id)objectForKey:(NSString *)key
{
	id obj = [self.themeDictionary valueForKeyPath:key];
	if (!obj && self.parentTheme) {
		obj = [self.parentTheme objectForKey:key];
    }
	return obj;
}


- (BOOL)boolForKey:(NSString *)key {

	id obj = [self objectForKey:key];
	if (obj == nil)
		return NO;
	return [obj boolValue];
}


- (NSString *)stringForKey:(NSString *)key {
	
	id obj = [self objectForKey:key];
	if (obj == nil)
		return nil;
	if ([obj isKindOfClass:[NSString class]])
		return obj;
	if ([obj isKindOfClass:[NSNumber class]])
		return [obj stringValue];
	return nil;
}


- (NSInteger)integerForKey:(NSString *)key {

	id obj = [self objectForKey:key];
	if (obj == nil)
		return 0;
	return [obj integerValue];
}


- (CGFloat)floatForKey:(NSString *)key {
	
	id obj = [self objectForKey:key];
	if (obj == nil)
		return  0.0f;
	return [obj floatValue];
}


- (NSTimeInterval)timeIntervalForKey:(NSString *)key {

	id obj = [self objectForKey:key];
	if (obj == nil)
		return 0.0;
	return [obj doubleValue];
}


- (TKO_IMAGE *)imageForKey:(NSString *)key {
	
	NSString *imageName = [self stringForKey:key];
	if (stringIsEmpty(imageName))
		return nil;
	
	return [TKO_IMAGE imageNamed:imageName];
}


- (TKO_COLOR *)colorForKey:(NSString *)key {

	TKO_COLOR *cachedColor = [self.colorCache objectForKey:key];
	if (cachedColor != nil)
		return cachedColor;
    
	NSString *colorString = [self stringForKey:key];
    
    TKO_COLOR *color;
    
    if ([colorString isEqualToString:@"textColor"])
        color = [TKO_COLOR textColor];
    else if ([colorString isEqualToString:@"controlColor"])
        color = [TKO_COLOR controlColor];
    else if ([colorString isEqualToString:@"grayColor"])
        color = [TKO_COLOR grayColor];
    else if ([colorString isEqualToString:@"darkGrayColor"])
        color = [TKO_COLOR darkGrayColor];
    else if ([colorString isEqualToString:@"lightGrayColor"])
        color = [TKO_COLOR lightGrayColor];
    else
        color = colorWithHexString(colorString);
    
//    if (color == nil)
//        color = colorWithHexString(key);
    
	if (color == nil)
		color = [TKO_COLOR blackColor];

	[self.colorCache setObject:color
                        forKey:key];

	return color;
}


- (NSGradient *)colorGradientForKey:(NSString *)key
{
    NSGradient * cachedGradient = [self.gradientCache objectForKey:key];
    if (cachedGradient != nil) return cachedGradient;
    
//    NSString * startColorKey   = [self stringForKey:[key stringByAppendingString:@"Start"]];
//    NSString * endColorKey     = [self stringForKey:[key stringByAppendingString:@"End"]];
    
    NSColor * startColor = [self colorForKey:[key stringByAppendingString:@"Start"]];
    NSColor * endColor = [self colorForKey:[key stringByAppendingString:@"End"]];
    
//    NSGradient * gradient = [[NSGradient alloc] initWithStartingColor:[self colorForKey:startColorKey]
//                                                          endingColor:[self colorForKey:endColorKey]];

    NSGradient * gradient = [[NSGradient alloc] initWithStartingColor:startColor
                                                          endingColor:endColor];

    [self.gradientCache setObject:gradient forKey:key];
    return gradient;
//    TKORGBAComponents start = [startColorKey rgbaComponents];
//    TKORGBAComponents end = [endColorKey rgbaComponents];
//    CGColorRef startRef = CGColorCreateGenericRGB(start.red, start.green, start.blue, start.alpha);
//    CGColorRef endRef   = CGColorCreateGenericRGB(end.red, end.green, end.blue, end.alpha);
    
//    return @[ CFBridgingRelease(startRef), CFBridgingRelease(endRef) ];
//    return @[colorWithHexString(startColorKey), colorWithHexString(endColorKey)];
}


- (TKO_EDGE_INSETS)edgeInsetsForKey:(NSString *)key {

	CGFloat left = [self floatForKey:[key stringByAppendingString:@"Left"]];
	CGFloat top = [self floatForKey:[key stringByAppendingString:@"Top"]];
	CGFloat right = [self floatForKey:[key stringByAppendingString:@"Right"]];
	CGFloat bottom = [self floatForKey:[key stringByAppendingString:@"Bottom"]];

    TKO_EDGE_INSETS edgeInsets = {.top = top, .left = left, .bottom = bottom, .right = right};
	return edgeInsets;
}


- (TKO_FONT *)fontForKey:(NSString *)key {

	TKO_FONT *cachedFont = [self.fontCache objectForKey:key];
	if (cachedFont != nil)
		return cachedFont;
    
	NSString *fontName = [self stringForKey:key];
	CGFloat fontSize = [self floatForKey:[key stringByAppendingString:@"Size"]];

	if (fontSize < 1.0f)
		fontSize = [TKO_FONT systemFontSizeForControlSize:NSRegularControlSize]; // Cross-platform?

	TKO_FONT *font = nil;
    
	if (stringIsEmpty(fontName))
		font = [TKO_FONT systemFontOfSize:fontSize];
	else
		font = [TKO_FONT fontWithName:fontName size:fontSize];

	if (font == nil)
		font = [TKO_FONT systemFontOfSize:fontSize];
    
	[self.fontCache setObject:font forKey:key];

	return font;
}


- (CGPoint)pointForKey:(NSString *)key {

	CGFloat pointX = [self floatForKey:[key stringByAppendingString:@"X"]];
	CGFloat pointY = [self floatForKey:[key stringByAppendingString:@"Y"]];

	CGPoint point = CGPointMake(pointX, pointY);
	return point;
}


- (CGSize)sizeForKey:(NSString *)key {

	CGFloat width = [self floatForKey:[key stringByAppendingString:@"Width"]];
	CGFloat height = [self floatForKey:[key stringByAppendingString:@"Height"]];

	CGSize size = CGSizeMake(width, height);
	return size;
}


//- (UIViewAnimationOptions)curveForKey:(NSString *)key {
//    
//	NSString *curveString = [self stringForKey:key];
//	if (stringIsEmpty(curveString))
//		return UIViewAnimationOptionCurveEaseInOut;
//
//	curveString = [curveString lowercaseString];
//	if ([curveString isEqualToString:@"easeinout"])
//		return UIViewAnimationOptionCurveEaseInOut;
//	else if ([curveString isEqualToString:@"easeout"])
//		return UIViewAnimationOptionCurveEaseOut;
//	else if ([curveString isEqualToString:@"easein"])
//		return UIViewAnimationOptionCurveEaseIn;
//	else if ([curveString isEqualToString:@"linear"])
//		return UIViewAnimationOptionCurveLinear;
//    
//	return UIViewAnimationOptionCurveEaseInOut;
//}


//- (VSAnimationSpecifier *)animationSpecifierForKey:(NSString *)key {
//
//	VSAnimationSpecifier *animationSpecifier = [VSAnimationSpecifier new];
//
//	animationSpecifier.duration = [self timeIntervalForKey:[key stringByAppendingString:@"Duration"]];
//	animationSpecifier.delay = [self timeIntervalForKey:[key stringByAppendingString:@"Delay"]];
//	animationSpecifier.curve = [self curveForKey:[key stringByAppendingString:@"Curve"]];
//
//	return animationSpecifier;
//}


- (TKOTextCaseTransform)textCaseTransformForKey:(NSString *)key {

	NSString *s = [self stringForKey:key];
	if (s == nil)
		return TKOTextCaseTransformNone;

	if ([s caseInsensitiveCompare:@"lowercase"] == NSOrderedSame)
		return TKOTextCaseTransformLower;
	else if ([s caseInsensitiveCompare:@"uppercase"] == NSOrderedSame)
		return TKOTextCaseTransformUpper;

	return TKOTextCaseTransformNone;
}


@end


//@implementation TKOTheme (Animations)
//
//
//- (void)animateWithAnimationSpecifierKey:(NSString *)animationSpecifierKey
//                              animations:(void (^)(void))animations
//                              completion:(void (^)(BOOL finished))completion {
//
//    TKOAnimationSpecifier *animationSpecifier = [self animationSpecifierForKey:animationSpecifierKey];
//
//    [UIView animateWithDuration:animationSpecifier.duration
//                          delay:animationSpecifier.delay
//                        options:animationSpecifier.curve
//                     animations:animations completion:completion];
//}
//
//@end


#pragma mark -

//@implementation TKOAnimationSpecifier
//
//@end


static BOOL stringIsEmpty(NSString *s) {
	return s == nil || [s length] == 0;
}


static TKO_COLOR *colorWithHexString(NSString *hexString) {

	/*Picky. Crashes by design.*/
	
	if (stringIsEmpty(hexString))
		return [TKO_COLOR blackColor];

	NSMutableString *s = [hexString mutableCopy];
	[s replaceOccurrencesOfString:@"#" withString:@"" options:0 range:NSMakeRange(0, [hexString length])];
	CFStringTrimWhitespace((__bridge CFMutableStringRef)s);

	NSString *redString = [s substringToIndex:2];
	NSString *greenString = [s substringWithRange:NSMakeRange(2, 2)];
	NSString *blueString = [s substringWithRange:NSMakeRange(4, 2)];

	unsigned int red = 0, green = 0, blue = 0;
	[[NSScanner scannerWithString:redString] scanHexInt:&red];
	[[NSScanner scannerWithString:greenString] scanHexInt:&green];
	[[NSScanner scannerWithString:blueString] scanHexInt:&blue];

	return [TKO_COLOR colorWithRed:(CGFloat)red/255.0f green:(CGFloat)green/255.0f blue:(CGFloat)blue/255.0f alpha:1.0f];
}
