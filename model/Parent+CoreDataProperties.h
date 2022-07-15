//
//  Parent+CoreDataProperties.h
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 12.01.2022.
//
//

#import "Parent+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Parent (CoreDataProperties)

+ (NSFetchRequest<Parent *> *)fetchRequest;


@end

NS_ASSUME_NONNULL_END
