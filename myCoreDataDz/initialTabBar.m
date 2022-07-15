//
//  initialTabBar.m
//  coreDataDz
//
//  Created by Valeriy Trusov on 27.12.2021.
//

#import "initialTabBar.h"
#import "ViewController.h"
#import "coursesController.h"

@interface initialTabBar ()

@end

@implementation initialTabBar

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    
    self.tabBar.backgroundColor = [UIColor clearColor];
    self.tabBar.barTintColor = [UIColor whiteColor];
    
}

@end
