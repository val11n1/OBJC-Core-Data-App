//
//  teacherController.h
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 13.01.2022.
//

#import "coreDataViewContrTableViewController.h"

@class createTeacherController;

NS_ASSUME_NONNULL_BEGIN

@interface teacherController : coreDataViewContrTableViewController

@property (strong, nonatomic) createTeacherController* createTeacherContrDelegate;

@end

NS_ASSUME_NONNULL_END
