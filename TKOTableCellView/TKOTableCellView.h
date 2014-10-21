//
//  TKOTableCellView.h
//
//  Created by Todd Olsen on 10/14/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

@import Cocoa;

@interface TKOTableCellView : NSTableCellView

@property (nonatomic) NSMutableArray * hidingViews;
@property (nonatomic) BOOL mightShowViews;
//@property (nonatomic) BOOL selected;

@end
