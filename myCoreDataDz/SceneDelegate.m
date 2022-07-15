//
//  SceneDelegate.m
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 30.12.2021.
//

#import "SceneDelegate.h"
#import "AppDelegate.h"
#import "initialTabBar.h"
#import "ViewController.h"
#import "coursesController.h"
#import "dataManager.h"
#import "objectController.h"
#import "teacherController.h"




@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    
    UITabBarItem* personItem = [[UITabBarItem alloc] init];
      
    personItem.image = [[UIImage imageNamed:@"person"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    ViewController* usersController = [[ViewController alloc] init];
    usersController.tabBarItem = personItem;
    personItem.title = @"Users";
    [personItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:(UIControlStateNormal)];
    [personItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor purpleColor]} forState:(UIControlStateSelected)];
    
    UINavigationController* navigationForUsers = [[UINavigationController alloc] initWithRootViewController:usersController];
    
    
    coursesController* coursesVc = [[coursesController alloc] init];
    
    UITabBarItem* coursesBarItem = [[UITabBarItem alloc] init];
    
    coursesBarItem.image = [[UIImage imageNamed:@"courses"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    coursesBarItem.title = @"Courses";
    [coursesBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor blackColor]} forState:(UIControlStateNormal)];
    [coursesBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor purpleColor]} forState:(UIControlStateSelected)];
    
    coursesVc.tabBarItem = coursesBarItem;
    
    UINavigationController* navigationForCourses = [[UINavigationController alloc] initWithRootViewController:coursesVc];
    
    
    objectController* objectVc = [[objectController alloc] init];
    
    UITabBarItem* objectBarItem = [[UITabBarItem alloc] init];
    
    objectBarItem.image = [[UIImage imageNamed:@"object"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    objectBarItem.title = @"Objects";
    [objectBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor blackColor]} forState:(UIControlStateNormal)];
    [objectBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor purpleColor]} forState:(UIControlStateSelected)];
    objectVc.tabBarItem = objectBarItem;
    
    UINavigationController* navigationForObjects = [[UINavigationController alloc] initWithRootViewController:objectVc];
    
    
    teacherController* teacherVc = [[teacherController alloc] init];
    
    UITabBarItem* teacherBarItem = [[UITabBarItem alloc] init];
    
    teacherBarItem.image = [[UIImage imageNamed:@"teacher"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    teacherBarItem.title = @"Objects";
    [teacherBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor blackColor]} forState:(UIControlStateNormal)];
    [teacherBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor purpleColor]} forState:(UIControlStateSelected)];
    teacherVc.tabBarItem = teacherBarItem;
    
    UINavigationController* navigationForTeacher = [[UINavigationController alloc] initWithRootViewController:teacherVc];
    
    initialTabBar* tabBar = [[initialTabBar alloc]init];
    tabBar.viewControllers = @[navigationForUsers, navigationForCourses, navigationForObjects, navigationForTeacher];

    
    self.window.rootViewController = tabBar;
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.

    // Save changes in the application's managed object context when the application transitions to the background.
    [[dataManagerClass sharedManager] saveContext];
}


@end
