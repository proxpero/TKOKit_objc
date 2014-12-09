//
//  TKOHeaderCellView.m
//
//  Created by Todd Olsen on 10/1/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOHeaderCellView.h"
#import "TKOFormat.h"

@interface TKOHeaderCellView ()
@end

@implementation TKOHeaderCellView

- (void)setObjectValue:(id)objectValue
{
    [super setObjectValue:objectValue];
    self.textField.stringValue = [[objectValue name] uppercaseString];
//    [self.hidingViews addObjectsFromArray:@[self.addButton, self.removeButton]];
}


@end
