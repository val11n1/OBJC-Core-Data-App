//
//  allUsersController.h
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 07.01.2022.
//

#import <UIKit/UIKit.h>
#import "coreDataViewContrTableViewController.h"
#import "createCourceController.h"


@class Cource;
@class createUserController;

NS_ASSUME_NONNULL_BEGIN

@interface allUsersController : coreDataViewContrTableViewController

@property (strong, nonatomic) Cource* currentCource;
@property (strong, nonatomic) createCourceController* createCourcesContrDelegate;

@end

NS_ASSUME_NONNULL_END
