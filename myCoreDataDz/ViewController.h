//
//  ViewController.h
//  coreDataDz
//
//  Created by Valeriy Trusov on 27.12.2021.
//

#import <UIKit/UIKit.h>
#import "coreDataViewContrTableViewController.h"

@class createUserController;

@interface ViewController : coreDataViewContrTableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITextField* firstNameTextField;
@property (strong, nonatomic) UITextField* lastNameTextField;
@property (strong, nonatomic) UITextField* mailTextField;

@property (strong, nonatomic) createUserController* createUserControllerDelegate;

@end

