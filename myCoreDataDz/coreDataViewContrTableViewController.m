//
//  coreDataViewContrTableViewController.m
//  coreDataDz
//
//  Created by Valeriy Trusov on 29.12.2021.
//

#import "coreDataViewContrTableViewController.h"
#import "dataManager.h"
#import "ViewController.h"
#import "createCourceController.h"
#import "coursesController.h"
#import "objectController.h"
#import "createObjectController.h"
#import "teacherController.h"
#import "createTeacherController.h"





@interface coreDataViewContrTableViewController ()

@end

@implementation coreDataViewContrTableViewController

@synthesize persistentContainer = _persistentContainer;



-(NSPersistentContainer*) persistentContainer {
    
    if (!_persistentContainer) {
        
        _persistentContainer = [[dataManagerClass sharedManager] persistentContainer];
    }
    return _persistentContainer;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

#pragma mark - Table view data source

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[self.fetchedResultController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultController sections] [section];
    
    return [sectionInfo numberOfObjects];
}

-(void) configureCell:(UITableViewCell*) cell atIndexPath:(NSIndexPath*) indexPath {
    
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:identifier];
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSManagedObjectContext* context = [self.fetchedResultController managedObjectContext];
        [context deleteObject:[self.fetchedResultController objectAtIndexPath:indexPath]];
        
        NSError* error = nil;
        
        if (![context save:&error]) {
            
            NSLog(@"ERROR: %@",[error localizedDescription]);
            abort();
        }
        
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

#pragma mark - NSFetchedResultsControllerDelegate

-(void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView beginUpdates];
}

-(void) controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch (type) {
            
        case NSFetchedResultsChangeInsert:
            
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:(UITableViewRowAnimationFade)];
            break;
            
        
        case NSFetchedResultsChangeDelete:
            
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:(UITableViewRowAnimationFade)];
            
            break;
            
        case NSFetchedResultsChangeMove:
            
            
            break;
        case NSFetchedResultsChangeUpdate:
            
            
            break;
    }
}

-(void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView* tableView = self.tableView;
    
    switch (type) {
            
        case NSFetchedResultsChangeInsert:
            
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:(UITableViewRowAnimationFade)];
            break;
            
            
        case NSFetchedResultsChangeDelete:
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
            break;
            
        case NSFetchedResultsChangeMove:
            
            
            break;
            
        case NSFetchedResultsChangeUpdate:
            
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
    }
}

-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [self.tableView endUpdates];
    [self.tableView reloadData];
}

#pragma mark - Supporting methods

-(void) reloadAllViewControllers {
    
    
    for (UINavigationController* nav in self.tabBarController.viewControllers) {
        
        UITableViewController* tableview = [nav.viewControllers firstObject];
        
        if ([tableview isKindOfClass:[ViewController class]]) {
            
            ViewController* vc = (ViewController*)tableview;
            
            if (vc.createUserControllerDelegate) {
                
                UITableViewController* tableViewController = (UITableViewController*)vc.createUserControllerDelegate;
                [tableViewController.tableView reloadData];
            }
            
        }else if ([tableview isKindOfClass:[coursesController class]]){
            
            coursesController* vc1 = (coursesController*)tableview;
            if (vc1.createCourceControllerDelegate) {

                UITableViewController* tableViewController = (UITableViewController*)vc1.createCourceControllerDelegate;
                [tableViewController.tableView reloadData];
                
            }
        }else if ([tableview isKindOfClass:[objectController class]]) {
           
            objectController* vc2 = (objectController*)tableview;
            [vc2.creatingObjectContr sortingArrayWithCources];
            if (vc2.creatingObjectContr) {

                UITableViewController* tableViewController = (UITableViewController*)vc2.creatingObjectContr;
                [tableViewController.tableView reloadData];
                
            }
            
            
        }else {
            
            teacherController* vc3 = (teacherController*)tableview;
            [vc3.createTeacherContrDelegate sortingArrayWithCources];
            
            
            if (vc3.createTeacherContrDelegate) {

                [vc3.createTeacherContrDelegate.tableView reloadData];
            }
            
        }
    }
}

@end

