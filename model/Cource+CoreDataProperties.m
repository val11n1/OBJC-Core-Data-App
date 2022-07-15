//
//  Cource+CoreDataProperties.m
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 12.01.2022.
//
//

#import "Cource+CoreDataProperties.h"

@implementation Cource (CoreDataProperties)

+ (NSFetchRequest<Cource *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Cource"];
}

@dynamic name;
@dynamic obj;
@dynamic students;
@dynamic teacher;

@end
