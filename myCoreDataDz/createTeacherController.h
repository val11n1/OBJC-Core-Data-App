//
//  createTeacherController.h
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 13.01.2022.
//

#import "teacherController.h"

@class Teacher;

NS_ASSUME_NONNULL_BEGIN

@interface createTeacherController : teacherController <UITextFieldDelegate>

@property (strong, nonatomic) Teacher* currentTeacher;
@property (strong, nonatomic) Teacher* newestTeacher;
@property (strong, nonatomic) UITextField* teacherFirstNameTextField;
@property (strong, nonatomic) UITextField* teacherLastNameTextField;
@property (strong, nonatomic) NSArray* arrayWithCources;


-(void) sortingArrayWithCources;

@end

NS_ASSUME_NONNULL_END
