//
//  allUsersController.m
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 07.01.2022.
//

#import "allUsersController.h"
#import <CoreData/NSEntityDescription.h>
#import "User+CoreDataClass.h"
#import "Cource+CoreDataClass.h"



@interface allUsersController ()

@property (strong, nonatomic) NSMutableSet* setWithUsers;

@end

@implementation allUsersController

@synthesize fetchedResultController = _fetchedResultController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:(UIBarButtonItemStylePlain) target:self action:@selector(actionBack:)];
    backButton.tintColor = [UIColor blackColor];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    if (self.createCourcesContrDelegate.currentCource) {
        
        self.setWithUsers = [NSMutableSet setWithSet:self.createCourcesContrDelegate.currentCource.students];
        
    }else {
        
        self.setWithUsers = [NSMutableSet setWithSet:self.createCourcesContrDelegate.newestCource.students];
    }
    
    self.navigationItem.title = @"All users";
    
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

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString* identifier = @"studentCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:identifier];
    }
    
    UIListContentConfiguration* conf = [UIListContentConfiguration valueCellConfiguration];
    
    
    User* user = [self.fetchedResultController objectAtIndexPath:indexPath];
    
    conf.text = [NSString stringWithFormat:@"User #%d",(int)indexPath.row + 1];
    conf.secondaryText = [NSString stringWithFormat:@"%@ %@",user.firstName, user.lastName];

    
    if ([self.setWithUsers containsObject:user]) {
        
        conf.image = [UIImage systemImageNamed:@"checkmark"];
        conf.imageProperties.tintColor = [UIColor blackColor];
    }
    
    cell.contentConfiguration = conf;

    return cell;
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

#pragma mark - UITableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    User* user = [self.fetchedResultController objectAtIndexPath:indexPath];
    
        
        if ([self.setWithUsers containsObject:user]) {
            
            [self.setWithUsers removeObject:user];
            [self.currentCource removeStudentsObject:user];
            
        }else {
            
            [self.setWithUsers addObject:user];
            [self.currentCource addStudentsObject:user];
      
}
    
    [self.tableView reloadData];
}


#pragma mark - Actions

-(void) actionBack:(UIBarButtonItem*) sender {
    
    if (self.createCourcesContrDelegate) {
      
        [self.createCourcesContrDelegate sortStudentsArray];
    }
    
    [self reloadAllViewControllers];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
