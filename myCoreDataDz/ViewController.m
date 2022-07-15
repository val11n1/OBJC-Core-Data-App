//
//  ViewController.m
//  coreDataDz
//
//  Created by Valeriy Trusov on 27.12.2021.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <Foundation/Foundation.h>
#import <CoreData/NSPersistentStoreDescription.h>
#import "coreDataViewContrTableViewController.h"
#import "createUser.h"
#import "User+CoreDataClass.h"


@interface ViewController ()

@property (strong, nonatomic) NSArray* allUsers;


@end



@implementation ViewController

@synthesize fetchedResultController = _fetchedResultController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
   
    
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"plus"] style:(UIBarButtonItemStylePlain) target:self action:@selector(actionAdd:)];
    addButton.tintColor = [UIColor blackColor];
    
    self.navigationItem.leftBarButtonItem = addButton;
    self.navigationItem.title = @"Users";
    
    
}

-(NSFetchedResultsController*) fetchedResultController {
    
    if (_fetchedResultController != nil) {
        return _fetchedResultController;
    }
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.persistentContainer.viewContext];
    
    [request setEntity:description];
    [request setFetchBatchSize:25];
    
    NSSortDescriptor* firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor* lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    
    [request setSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
    
    NSFetchedResultsController* fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.persistentContainer.viewContext sectionNameKeyPath:nil cacheName:nil];
    
    fetchedResultsController.delegate = self;
    self.fetchedResultController = fetchedResultsController;
    
    NSError* error = nil;
    
    if (![self.fetchedResultController performFetch:&error]) {
        
        NSLog(@"ERROR:%@",[error userInfo]);
        abort();
    }
    return _fetchedResultController;
}


#pragma mark - UITableViewDataSource



-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:identifier];
    }
    
    UIListContentConfiguration* configuration = cell.defaultContentConfiguration;
    configuration.text = [NSString stringWithFormat:@"User #%d",(int)indexPath.row + 1];
    
    User* user = [self.fetchedResultController objectAtIndexPath:indexPath];
    
    configuration.secondaryText = [NSString stringWithFormat:@"%@ %@",user.firstName, user.lastName];
    
    cell.contentConfiguration = configuration;
    cell.clipsToBounds = YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    return cell;
 }

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [super tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
        
        [self reloadAllViewControllers];
        
    }
}

#pragma mark - UITableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    createUserController* vc = [[createUserController alloc] init];
    
    self.createUserControllerDelegate = vc;
    vc.chosenUser = [self.fetchedResultController objectAtIndexPath:indexPath];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - Actions


-(void) actionAdd:(UIBarButtonItem*) sender {
    
    createUserController* vc = [[createUserController alloc] init];
    self.createUserControllerDelegate = vc;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
