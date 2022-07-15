//
//  allCourcesController.h
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 08.01.2022.
//

#import "coreDataViewContrTableViewController.h"
#import "createUser.h"


@class Obj;
@class createObjectController;
@class Teacher;
@class createTeacherController;

NS_ASSUME_NONNULL_BEGIN

@interface allCourcesController : coreDataViewContrTableViewController

@property (strong, nonatomic) createUserController* delegate;
@property (strong, nonatomic) createObjectController* createObjectControllerDelegate;
@property (strong, nonatomic) createTeacherController* createTeacherControllerDelegate;


@property (strong, nonatomic) Obj* currentObj;
@property (strong, nonatomic) Teacher* currentTeacher;




@end

NS_ASSUME_NONNULL_END
