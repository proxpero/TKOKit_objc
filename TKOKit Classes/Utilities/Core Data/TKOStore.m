//
//  TKOStore.m
//  TKOKit
//
//  Created by Todd Olsen on 10/5/13.
//  Copyright (c) 2013 Todd Olsen. All rights reserved.
//

#import "TKOStore.h"

NSString * const TKOStoreModelName      = @"Keystone_v1_2";
NSString * const TKOStoreStoreName      = @"problemui_db.sqlite";
NSString * const TKOStoreArchiveName    = @"problemuidb_backup";
NSString * const TKOSeedDataName        = @"SATSeedData";

@interface TKOStore ()

@property (nonatomic,strong,readwrite) NSManagedObjectContext * mainManagedObjectContext;
@property (nonatomic,strong) NSManagedObjectModel * managedObjectModel;
@property (nonatomic,strong) NSPersistentStoreCoordinator * persistentStoreCoordinator;

@property (nonatomic,strong) NSURL* modelURL;
@property (nonatomic,strong) NSURL* storeURL;

@end



@implementation TKOStore
{
    BOOL _deleteStore;
    BOOL _importSeedData;
}


+ (instancetype)defaultStore
{
    static dispatch_once_t once;
    static TKOStore * _defaultStore = nil;
    dispatch_once(&once, ^{
        _defaultStore = [[self alloc] initWithStoreURL:[self storeURL]
                                              modelURL:[self modelURL]
                                           deleteStore:NO
                                        importSeedData:NO];
    });
    return _defaultStore;
}


- (instancetype)initWithTemporaryStoreType
{
    self = [super init]; if (!self) return nil;
    
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    id store = [_persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType
                                                         configuration:nil
                                                                   URL:nil
                                                               options:nil
                                                                 error:NULL];

    NSAssert(store, @"No store");
    
    _mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _mainManagedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
    
    return self;
}


- (id)initWithStoreURL:(NSURL *)storeURL
              modelURL:(NSURL *)modelURL
{
    self = [super init]; if (!self) return nil;
    
    _storeURL = storeURL;
    _modelURL = modelURL;
    [self setupManagedObjectContext];
    [self setupSaveNotification];
    
    return self;
}


- (id)initWithStoreURL:(NSURL *)storeURL
              modelURL:(NSURL *)modelURL
           deleteStore:(BOOL)deleteStore
{
    _deleteStore = deleteStore;
    self = [self initWithStoreURL:storeURL
                         modelURL:modelURL];
    return self;
}


- (id)initWithStoreURL:(NSURL *)storeURL
              modelURL:(NSURL *)modelURL
           deleteStore:(BOOL)deleteStore
        importSeedData:(BOOL)importSeedData
{
    _importSeedData = importSeedData;
    self = [self initWithStoreURL:storeURL
                         modelURL:modelURL
                      deleteStore:deleteStore];
    
    return self;
}


- (void)setupManagedObjectContext
{
    _mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_mainManagedObjectContext setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
    if (!_mainManagedObjectContext.undoManager) {
        _mainManagedObjectContext.undoManager = [[NSUndoManager alloc] init];
    }
        
    if (_importSeedData) {
        [self importSeedData];
    }
}


- (void)setupSaveNotification
{
    [[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * note) {
                                                      NSManagedObjectContext * moc = self->_mainManagedObjectContext;
                                                      if (![note.object isEqual:moc]) {
                                                          [moc performBlock:^(){
                                                              [moc mergeChangesFromContextDidSaveNotification:note];
                                                              NSLog(@"changes merged");
                                                          }];
                                                      }
                                                  }];
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext * managedObjectContext = self.mainManagedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


- (void)setupInitialData
{
    
}


- (void)importSeedData
{
//    [TKOBaseEntity importSeedDataAtURL:[TKOStore seedURL] context:[self newPrivateContext]];
}


- (NSManagedObjectContext *)mainContext
{
    if (_mainManagedObjectContext != nil) {
        return _mainManagedObjectContext;
    }
    
    [self setupManagedObjectContext];
    return _mainManagedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
    return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    if (_deleteStore) {
        NSLog(@"Deleting Store");
        [[NSFileManager defaultManager] removeItemAtURL:self.storeURL
                                                      error:NULL];
    }
    
    NSError * error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:_storeURL
                                                         options:nil
                                                           error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)newPrivateContext
{
    NSManagedObjectContext * context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.persistentStoreCoordinator = self.persistentStoreCoordinator;
    return context;
}


+ (NSURL *)storeURL
{
    NSURL * appSupport = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory
                                                                        inDomain:NSUserDomainMask
                                                               appropriateForURL:nil
                                                                          create:YES
                                                                           error:NULL];
    return [appSupport URLByAppendingPathComponent:TKOStoreStoreName];
}


+ (NSURL *)archiveURL
{
    NSURL * appSupport = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory
                                                                inDomain:NSUserDomainMask
                                                       appropriateForURL:nil
                                                                  create:YES
                                                                   error:NULL];
    return [appSupport URLByAppendingPathComponent:TKOStoreArchiveName];
}


+ (NSURL *)modelURL
{
    return [[NSBundle mainBundle] URLForResource:TKOStoreModelName
                                   withExtension:@"momd"];
}


+ (NSURL *)seedURL
{
    return [[NSBundle mainBundle] URLForResource:TKOSeedDataName
                                   withExtension:@"plist"];
}


@end

