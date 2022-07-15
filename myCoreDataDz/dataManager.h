//
//  dataManagerClass.h
//  coreDataDz
//
//  Created by Valeriy Trusov on 29.12.2021.
//

#import <Foundation/Foundation.h>
#import <CoreData/NSPersistentStoreDescription.h>
#import <CoreData/NSPersistentContainer.h>

NS_ASSUME_NONNULL_BEGIN

@interface dataManagerClass : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;
+(dataManagerClass*) sharedManager;

@end

NS_ASSUME_NONNULL_END
