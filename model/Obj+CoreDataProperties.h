//
//  Obj+CoreDataProperties.h
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 12.01.2022.
//
//

#import "Obj+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Obj (CoreDataProperties)

+ (NSFetchRequest<Obj *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Cource *> *cources;
@property (nullable, nonatomic, retain) NSSet<Teacher *> *teacher;

@end

@interface Obj (CoreDataGeneratedAccessors)

- (void)addCourcesObject:(Cource *)value;
- (void)removeCourcesObject:(Cource *)value;
- (void)addCources:(NSSet<Cource *> *)values;
- (void)removeCources:(NSSet<Cource *> *)values;

- (void)addTeacherObject:(Teacher *)value;
- (void)removeTeacherObject:(Teacher *)value;
- (void)addTeacher:(NSSet<Teacher *> *)values;
- (void)removeTeacher:(NSSet<Teacher *> *)values;

@end

NS_ASSUME_NONNULL_END
