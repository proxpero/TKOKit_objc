//
//  NSString+Geometrics.m
//  ProblemEditor
//
//  Created by Todd Olsen on 5/30/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "NSString+Geometrics.h"

NSInteger gNSStringGeometricsTypesetterBehavior = NSTypesetterLatestBehavior ;

@implementation NSAttributedString (Geometrics)

#pragma mark * Measure Attributed String

- (NSSize)sizeForWidth:(float)width
				height:(float)height
{
	NSSize answer = NSZeroSize ;
    if ([self length] > 0)
    {
		// Checking for empty string is necessary since Layout Manager will give the nominal
		// height of one line if length is 0.  Our API specifies 0.0 for an empty string.
		NSSize size = NSMakeSize(width, height) ;
		NSTextContainer *textContainer = [[NSTextContainer alloc] initWithContainerSize:size] ;
		NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self] ;
		NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init] ;
		[layoutManager addTextContainer:textContainer] ;
		[textStorage addLayoutManager:layoutManager] ;
		[layoutManager setHyphenationFactor:0.0] ;
		if (gNSStringGeometricsTypesetterBehavior != NSTypesetterLatestBehavior) {
			[layoutManager setTypesetterBehavior:gNSStringGeometricsTypesetterBehavior] ;
		}
		// NSLayoutManager is lazy, so we need the following kludge to force layout:
		[layoutManager glyphRangeForTextContainer:textContainer] ;
        
		answer = [layoutManager usedRectForTextContainer:textContainer].size ;
		// Adjust if there is extra height for the cursor
		NSSize extraLineSize = [layoutManager extraLineFragmentRect].size;
		if (extraLineSize.height > 0)
        {
			answer.height -= extraLineSize.height;
		}
		
		// In case we changed it above, set typesetterBehavior back
		// to the default value.
		gNSStringGeometricsTypesetterBehavior = NSTypesetterLatestBehavior ;
	}
    
	return answer;
}

- (float)heightForWidth:(float)width
{
	return [self sizeForWidth:width
					   height:FLT_MAX].height ;
}

- (float)widthForHeight:(float)height
{
	return [self sizeForWidth:FLT_MAX
					   height:height].width ;
}

@end


@implementation NSString (Geometrics)

#pragma mark * Given String with Attributes

- (NSSize)sizeForWidth:(float)width
				height:(float)height
			attributes:(NSDictionary*)attributes
{
	NSSize answer ;
    
	NSAttributedString *astr = [[NSAttributedString alloc] initWithString:self
															   attributes:attributes] ;
	answer = [astr sizeForWidth:width
						 height:height] ;
	return answer ;
}

- (float)heightForWidth:(float)width
			 attributes:(NSDictionary*)attributes
{
	return [self sizeForWidth:width
					   height:FLT_MAX
				   attributes:attributes].height ;
}

- (float)widthForHeight:(float)height
			 attributes:(NSDictionary*)attributes
{
	return [self sizeForWidth:FLT_MAX
					   height:height
				   attributes:attributes].width ;
}

#pragma mark * Given String with Font

- (NSSize)sizeForWidth:(float)width
				height:(float)height
				  font:(NSFont*)font
{
	NSSize answer = NSZeroSize ;
    
	if (font == nil)
    {
		NSLog(@"[%@ %@]: Internal Error 561-3810: Nil font", [self class], NSStringFromSelector(_cmd)) ;
	}
	else
    {
		NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:
									font, NSFontAttributeName, nil] ;
		answer = [self sizeForWidth:width
							 height:height
						 attributes:attributes] ;
	}
    
	return answer ;
}

- (float)heightForWidth:(float)width
				   font:(NSFont*)font
{
	return [self sizeForWidth:width
					   height:FLT_MAX
						 font:font].height ;
}

- (float)widthForHeight:(float)height
				   font:(NSFont*)font
{
	return [self sizeForWidth:FLT_MAX
					   height:height
						 font:font].width ;
}

@end
