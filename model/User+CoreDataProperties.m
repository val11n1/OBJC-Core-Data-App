//
//  User+CoreDataProperties.m
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 12.01.2022.
//
//

#import "User+CoreDataProperties.h"

@implementation User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"User"];
}

@dynamic firstName;
@dynamic lastName;
@dynamic mail;
@dynamic cources;

@end
