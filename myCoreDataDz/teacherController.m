//
//  teacherController.m
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 13.01.2022.
//

#import "teacherController.h"
#import <CoreData/NSEntityDescription.h>
#import "Teacher+CoreDataClass.h"
#import "createTeacherController.h"




@interface teacherController ()

@end

@implementation teacherController

@synthesize fetchedResultController = _fetchedResultController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"plus"] style:(UIBarButtonItemStylePlain) target:self action:@selector(actionAdd:)];
    addButton.tintColor = [UIColor blackColor];
    
    self.navigationItem.leftBarButtonItem = addButton;
    self.navigationItem.title = @"Teachers";
}

-(NSFetchedResultsController*) fetchedResultController {
    
    if (_fetchedResultController != nil) {
        return _fetchedResultController;
    }
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"Teacher" inManagedObjectContext:self.persistentContainer.viewContext];
    
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
    
    static NSString* identifier = @"cellForTeacher";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] init];
    }
    
    UIListContentConfiguration* conf = [UIListContentConfiguration valueCellConfiguration];
    
    Teacher* teacher = [self.fetchedResultController objectAtIndexPath:indexPath];
    
    conf.text = [NSString stringWithFormat:@"Teacher #%d",(int)indexPath.row +1];
    conf.secondaryText = [NSString stringWithFormat:@"%@ %@", teacher.firstName, teacher.lastName];
    conf.secondaryTextProperties.color = [UIColor blackColor];
    cell.contentConfiguration = conf;
    
    return cell;
}

#pragma mark - Actions

-(void) actionAdd:(UIBarButtonItem*) sender {
    
    createTeacherController* vc = [[createTeacherController alloc] init];
    self.createTeacherContrDelegate = vc;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Teacher* teacher = [self.fetchedResultController objectAtIndexPath:indexPath];
    
    createTeacherController* vc = [[createTeacherController alloc] init];
    self.createTeacherContrDelegate = vc;
    vc.currentTeacher = teacher;
    
    [self.navigationController pushViewController:vc animated:YES];
}
 
@end
