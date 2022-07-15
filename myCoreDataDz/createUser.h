//
//  createUserController.h
//  coreDataDz
//
//  Created by Valeriy Trusov on 29.12.2021.
//

#import <UIKit/UIKit.h>
//#import "User+CoreDataClass.h"
//#import "Cource+CoreDataClass.h"
#import "ViewController.h"


@class User;
@class Cource;


NS_ASSUME_NONNULL_BEGIN

@interface createUserController : ViewController

@property (strong, nonatomic) User* chosenUser;
@property (strong, nonatomic) User* newestUser;
@property (strong, nonatomic) Cource* chosenCource;



@end

NS_ASSUME_NONNULL_END

