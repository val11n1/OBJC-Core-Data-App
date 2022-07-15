//
//  createCourceController.h
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 06.01.2022.
//

#import <UIKit/UIKit.h>
#import "coursesController.h"

@class Cource;

NS_ASSUME_NONNULL_BEGIN

@interface createCourceController : coursesController

@property (strong, nonatomic) UITextField* nameOfCourceTextfield;
@property (strong, nonatomic) Cource* currentCource;
@property (strong, nonatomic) Cource* newestCource;
@property (strong, nonatomic) NSArray* arrayOfStudents;



-(void) sortStudentsArray;

@end

NS_ASSUME_NONNULL_END
