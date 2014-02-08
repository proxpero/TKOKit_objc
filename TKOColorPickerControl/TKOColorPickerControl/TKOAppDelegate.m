//
//  TKOAppDelegate.m
//  TKOColorPickerControl
//
//  Created by Todd Olsen on 2/8/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import "TKOAppDelegate.h"
#import "TKOColorPickerView.h"

@implementation TKOAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //    The following code is unnecessary since the Target/Action are set in IB
    //    [self.colorPicker setTarget:self];
    //    [self.colorPicker setAction:@selector(colorPickerChangedColorAction:)];
}

- (IBAction)colorPickerChangedColorAction:(id)sender
{
    [self.colorWell setColor:self.colorPicker.selectedColor];
}

@end
