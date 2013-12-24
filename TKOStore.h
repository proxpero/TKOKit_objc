//
//  TKOStore.h
//  Anthology
//
//  Created by Todd Olsen on 10/5/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKOStore : NSObject

@property (nonatomic,strong,readonly) NSManagedObjectContext * mainManagedObjectContext;

- (id)initWithStoreURL:(NSURL*)storeURL
              modelURL:(NSURL*)modelURL;

- (id)initWithStoreURL:(NSURL*)storeURL
              modelURL:(NSURL*)modelURL
           deleteStore:(BOOL)deleteStore;

- (void)saveContext;
- (NSManagedObjectContext*)newPrivateContext;

@end
