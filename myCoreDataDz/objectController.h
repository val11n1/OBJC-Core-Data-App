//
//  objectController.h
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 09.01.2022.
//

#import <UIKit/UIKit.h>
#import "coreDataViewContrTableViewController.h"


@class createObjectController;

NS_ASSUME_NONNULL_BEGIN


@interface objectController : coreDataViewContrTableViewController

@property (strong, nonatomic) createObjectController* creatingObjectContr;

@end

NS_ASSUME_NONNULL_END
