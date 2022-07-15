//
//  User+CoreDataProperties.h
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 12.01.2022.
//
//

#import "User+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nullable, nonatomic, copy) NSString *mail;
@property (nullable, nonatomic, retain) NSSet<Cource *> *cources;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addCourcesObject:(Cource *)value;
- (void)removeCourcesObject:(Cource *)value;
- (void)addCources:(NSSet<Cource *> *)values;
- (void)removeCources:(NSSet<Cource *> *)values;

@end

NS_ASSUME_NONNULL_END
