//
//  Teacher+CoreDataProperties.h
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 12.01.2022.
//
//

#import "Teacher+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Teacher (CoreDataProperties)

+ (NSFetchRequest<Teacher *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nullable, nonatomic, retain) NSSet<Cource *> *cources;
@property (nullable, nonatomic, retain) Obj *obj;

@end

@interface Teacher (CoreDataGeneratedAccessors)

- (void)addCourcesObject:(Cource *)value;
- (void)removeCourcesObject:(Cource *)value;
- (void)addCources:(NSSet<Cource *> *)values;
- (void)removeCources:(NSSet<Cource *> *)values;

@end

NS_ASSUME_NONNULL_END
