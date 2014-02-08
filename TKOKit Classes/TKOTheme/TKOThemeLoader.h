//
//  TKOThemeLoader.m
//
//  Originally Created by Brent Simmons on 6/26/13.
//  Copyright (c) 2012 Q Branch LLC. All rights reserved.
//
//  Modified by TKO
//
#import <Foundation/Foundation.h>


@class TKOTheme;

@interface TKOThemeLoader : NSObject

@property (nonatomic, strong, readonly) TKOTheme *defaultTheme;
@property (nonatomic, strong, readonly) NSArray *themes;

- (TKOTheme *)themeNamed:(NSString *)themeName;

@end
