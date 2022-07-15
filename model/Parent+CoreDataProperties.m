//
//  Parent+CoreDataProperties.m
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 12.01.2022.
//
//

#import "Parent+CoreDataProperties.h"

@implementation Parent (CoreDataProperties)

+ (NSFetchRequest<Parent *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Parent"];
}


@end
