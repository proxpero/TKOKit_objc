//
//  TKOTheme.h
//
//  Originally Created by Brent Simmons on 6/26/13.
//  Copyright (c) 2012 Q Branch LLC. All rights reserved.
//
//  Modified by TKO
//

@import Cocoa;

#import "TKOPlatform.h"
#import "TKOThemeConstants.h"

typedef NS_ENUM(NSUInteger, TKOTextCaseTransform) {
    TKOTextCaseTransformNone,
    TKOTextCaseTransformUpper,
    TKOTextCaseTransformLower
};


@class VSAnimationSpecifier;

@interface TKOTheme : NSObject

- (id)initWithDictionary:(NSDictionary *)themeDictionary;

@property (nonatomic, strong) NSString *name;
@property (nonatomic) TKOTheme *parentTheme; /*can inherit*/

- (BOOL)boolForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key;
- (CGFloat)floatForKey:(NSString *)key;
- (TKO_IMAGE *)imageForKey:(NSString *)key; /*Via UIImage imageNamed:*/
- (TKO_COLOR *)colorForKey:(NSString *)key; /*123ABC or #123ABC: 6 digits, leading # allowed but not required*/
- (NSGradient *)colorGradientForKey:(NSString *)key;
- (TKO_EDGE_INSETS)edgeInsetsForKey:(NSString *)key; /*xTop, xLeft, xRight, xBottom keys*/
- (TKO_FONT *)fontForKey:(NSString *)key; /*x and xSize keys*/
- (CGPoint)pointForKey:(NSString *)key; /*xX and xY keys*/
- (CGSize)sizeForKey:(NSString *)key; /*xWidth and xHeight keys*/
- (NSTimeInterval)timeIntervalForKey:(NSString *)key;

//- (UIViewAnimationOptions)curveForKey:(NSString *)key; /*Possible values: easeinout, easeout, easein, linear*/
//- (TKOAnimationSpecifier *)animationSpecifierForKey:(NSString *)key; /*xDuration, xDelay, xCurve*/

- (TKOTextCaseTransform)textCaseTransformForKey:(NSString *)key; /*lowercase or uppercase -- returns VSTextCaseTransformNone*/

@end


@interface TKOTheme (Animations)

- (void)animateWithAnimationSpecifierKey:(NSString *)animationSpecifierKey
                              animations:(void (^)(void))animations
                              completion:(void (^)(BOOL finished))completion;

@end


//@interface TKOAnimationSpecifier : NSObject
//
//@property (nonatomic, assign) NSTimeInterval delay;
//@property (nonatomic, assign) NSTimeInterval duration;
//@property (nonatomic, assign) UIViewAnimationOptions curve;
//
//@end

