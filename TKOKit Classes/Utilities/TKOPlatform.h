//
//  TKOPlatform.h
//  TKOKit
//
//  Created by Todd Olsen on 12/24/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

@import Foundation;

#if TARGET_OS_IPHONE

#define TKO_IMAGE         UIImage
#define TKO_COLOR         UIColor
#define TKO_FONT          UIFont
#define TKO_EDGE_INSETS   UIEdgeInsets
#define TKOEdgeInsetsMake UIEdgeInsetsMake

#else

#define TKO_IMAGE         NSImage
#define TKO_COLOR         NSColor
#define TKO_FONT          NSFont
#define TKO_EDGE_INSETS   NSEdgeInsets
#define TKOEdgeInsetsMake NSEdgeInsetsMake

#endif


/*iOS: Documents/ directory.
 Mac: ~/Application Support/AppName/
 
 If nil, gets appName from Info.plist -- @"CFBundleExecutable" key.
 It creates the folder and intermediate folders if necessary.
 (appName is ignored on iOS.)
 
 If something goes wrong it returns nil. The error is NSLogged.
 Panic, at that point, is strongly indicated.*/

NSString * TKODataFolder(NSString * appName);


