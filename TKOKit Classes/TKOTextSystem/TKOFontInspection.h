//
//  TKOFontInspection.h
//  TKOFontInspectorViewDemo
//
//  Created by Todd Olsen on 2/11/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TKOTextViewFontDelegate <NSObject>
@optional
- (void)textViewDidChangeFont:(NSNotification *)notification;
@end

extern NSString * TKOTextViewDidChangeFontNotification;

@protocol TKOFontInspectorDelegate <NSObject>
@optional
- (void)fontInspectorDidModifyFontSize:(CGFloat)size;
- (void)fontInspectorDidModifyFontFamily:(NSString *)familyName;
- (void)fontInspectorDidModifyFontFace:(NSString *)faceName;
- (void)fontInspectorDidModifyBoldness:(BOOL)isBold;
- (void)fontInspectorDidModifyObliquity:(BOOL)isOblique;
- (void)fontInspectorDidModifyUnderlining:(BOOL)isUnderlined;
- (void)fontInspectorDidModifyTextColor:(NSColor *)color;
@end

extern NSString * TKOFontInspectorDidModifyFontSizeNotification;
extern NSString * TKOFontInspectorDidModifyFontFamilyNotification;