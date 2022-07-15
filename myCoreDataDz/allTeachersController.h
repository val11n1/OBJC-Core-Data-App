//
//  allTeachersController.h
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 13.01.2022.
//

#import "coreDataViewContrTableViewController.h"

@class Cource;

NS_ASSUME_NONNULL_BEGIN

@interface allTeachersController : coreDataViewContrTableViewController

@property (strong, nonatomic) Cource* currentCource;

@end

NS_ASSUME_NONNULL_END
