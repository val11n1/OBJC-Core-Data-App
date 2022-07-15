//
//  Obj+CoreDataProperties.m
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 12.01.2022.
//
//

#import "Obj+CoreDataProperties.h"

@implementation Obj (CoreDataProperties)

+ (NSFetchRequest<Obj *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Obj"];
}

@dynamic name;
@dynamic cources;
@dynamic teacher;

@end
