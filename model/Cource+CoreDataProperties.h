//
//  Cource+CoreDataProperties.h
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 12.01.2022.
//
//

#import "Cource+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Cource (CoreDataProperties)

+ (NSFetchRequest<Cource *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) Obj *obj;
@property (nullable, nonatomic, retain) NSSet<User *> *students;
@property (nullable, nonatomic, retain) Teacher *teacher;

@end

@interface Cource (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(User *)value;
- (void)removeStudentsObject:(User *)value;
- (void)addStudents:(NSSet<User *> *)values;
- (void)removeStudents:(NSSet<User *> *)values;

@end

NS_ASSUME_NONNULL_END
