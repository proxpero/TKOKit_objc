//
//  TKOStore.h
//  TKOKit
//
//  Created by Todd Olsen on 10/5/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

@import Foundation;
@import CoreData;

@interface TKOStore : NSObject

@property (nonatomic,strong,readonly) NSManagedObjectContext * mainManagedObjectContext;

+ (instancetype)defaultStore;
+ (NSURL *)archiveURL;

//- (instancetype)initWithStoreURL:(NSURL*)storeURL
//                        modelURL:(NSURL*)modelURL;

//- (instancetype)initWithStoreURL:(NSURL*)storeURL
//                        modelURL:(NSURL*)modelURL
//                     deleteStore:(BOOL)deleteStore;

- (instancetype)initWithTemporaryStoreType;

- (void)saveContext;
- (NSManagedObjectContext*)newPrivateContext;

@end
