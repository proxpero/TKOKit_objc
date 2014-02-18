//
//  TKOJumpbarCell.h
//  Keystone
//
//  Created by Todd Olsen on 12/29/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TKOTextTabCell.h"

@interface TKOJumpbarCell : TKOHeaderCell

@property (nonatomic) BOOL isLast;
@property (strong, nonatomic) NSImage * icon;
@end
