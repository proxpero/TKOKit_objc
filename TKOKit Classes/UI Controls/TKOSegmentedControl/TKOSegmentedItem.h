//
//  TKOSegmentedItem.h
//  TKOStackingSidebarDemo
//
//  Created by Todd Olsen on 7/5/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKOSegmentedItem : NSObject

@property (nonatomic) NSString * label;
@property (nonatomic) NSImage  * image;
@property (nonatomic) NSInteger tag;

- (instancetype)initWithLabel:(NSString *)label image:(NSImage *)image tag:(NSInteger)tag;

@end
