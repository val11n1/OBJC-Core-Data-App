//
//  createObjectController.h
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 10.01.2022.
//

#import "objectController.h"
//#import "Object+CoreDataClass.h"

@class Obj;

NS_ASSUME_NONNULL_BEGIN

@interface createObjectController : objectController <UITextFieldDelegate>

@property (strong, nonatomic) Obj* currentObject;
@property (strong, nonatomic) Obj* newestObject;
@property (strong, nonatomic) UITextField* nameOfObjectTextField;
@property (strong, nonatomic) NSArray* arrayWithCources;


-(void) sortingArrayWithCources;


@end

NS_ASSUME_NONNULL_END
