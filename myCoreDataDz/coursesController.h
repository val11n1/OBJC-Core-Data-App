//
//  coursesController.h
//  coreDataDz
//
//  Created by Valeriy Trusov on 28.12.2021.
//

#import <UIKit/UIKit.h>
#import "coreDataViewContrTableViewController.h"

@class createCourceController;

NS_ASSUME_NONNULL_BEGIN

@interface coursesController : coreDataViewContrTableViewController

@property (strong, nonatomic) createCourceController* createCourceControllerDelegate;

@end

NS_ASSUME_NONNULL_END
