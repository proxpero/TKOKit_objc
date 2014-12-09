//
//  TKOPlatform.m
//  TKOKit
//
//  Created by Todd Olsen on 12/24/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "TKOPlatform.h"

NSString * TKODataFolder(NSString * appName) {
    
#if TARGET_OS_IPHONE
    
    NSString * dataFolder = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
#else
    
    NSString * dataFolder = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	if (appName == nil) {
		appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
	}
	dataFolder = [dataFolder stringByAppendingPathComponent:appName];
	
#endif
    
	NSError *error = nil;
	
    if (![[NSFileManager defaultManager] createDirectoryAtPath:dataFolder
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:&error]) {
		NSLog(@"TKODataFolder error: %@", error);
		return nil;
    }
    
	return dataFolder;
}

