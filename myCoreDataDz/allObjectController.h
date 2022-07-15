//
//  allObjectController.h
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 11.01.2022.
//

#import "coreDataViewContrTableViewController.h"

@class Cource;
@class createCourceController;
NS_ASSUME_NONNULL_BEGIN

@interface allObjectController : coreDataViewContrTableViewController

@property (strong, nonatomic) Cource* currentCource;

//@property (strong, nonatomic) createCourceController* createCourceControllerDelegate;


@end

NS_ASSUME_NONNULL_END
