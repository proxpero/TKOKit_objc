//
//  TKOAppDelegate.h
//  TKOColorPickerControl
//
//  Created by Todd Olsen on 2/8/14.
//  Copyright (c) 2014 Todd Olsen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class TKOColorPickerView;

@interface TKOAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet TKOColorPickerView *colorPicker;
@property (weak) IBOutlet NSColorWell *colorWell;

- (IBAction)colorPickerChangedColorAction:(id)sender;


@end
