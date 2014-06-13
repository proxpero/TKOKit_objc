//
//  TKOThemeLoader.m
//
//  Originally Created by Brent Simmons on 6/26/13.
//  Copyright (c) 2012 Q Branch LLC. All rights reserved.
//
//  Modified by TKO
//

#import "TKOThemeLoader.h"
#import "TKOTheme.h"


@interface TKOThemeLoader ()

@property (nonatomic, strong, readwrite) TKOTheme *defaultTheme;
@property (nonatomic, strong, readwrite) NSArray *themes;
@end


@implementation TKOThemeLoader


- (id)init {
	
	self = [super init];
	if (self == nil)
		return nil;
	
	NSString *themesFilePath = [[NSBundle mainBundle] pathForResource:@"KeystoneThemes" ofType:@"plist"];
	NSDictionary *themesDictionary = [NSDictionary dictionaryWithContentsOfFile:themesFilePath];
	
	NSMutableArray *themes = [NSMutableArray array];
	for (NSString *oneKey in themesDictionary) {
		
		TKOTheme *theme = [[TKOTheme alloc] initWithDictionary:themesDictionary[oneKey]];
		if ([[oneKey lowercaseString] isEqualToString:@"default"])
			_defaultTheme = theme;
		theme.name = oneKey;
		[themes addObject:theme];
	}

    for (TKOTheme *oneTheme in themes) { /*All themes inherit from the default theme.*/
		if (oneTheme != _defaultTheme)
			oneTheme.parentTheme = _defaultTheme;
    }
    
	_themes = themes;
	
	return self;
}


- (TKOTheme *)themeNamed:(NSString *)themeName {

	for (TKOTheme *oneTheme in self.themes) {
		if ([themeName isEqualToString:oneTheme.name])
			return oneTheme;
	}

	return nil;
}

@end

