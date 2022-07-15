//
//  allTeachersController.m
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 13.01.2022.
//

#import "allTeachersController.h"
#import "Teacher+CoreDataClass.h"
#import "Cource+CoreDataClass.h"


@interface allTeachersController ()

@property (strong, nonatomic) Teacher* chosenTeacher;

@end

@implementation allTeachersController

@synthesize fetchedResultController = _fetchedResultController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:(UIBarButtonItemStylePlain) target:self action:@selector(actionBack:)];
    backButton.tintColor = [UIColor blackColor];
    
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.title = @"All Teachers";
    
    if (self.currentCource.teacher) {
        
        self.chosenTeacher = self.currentCource.teacher;
    }
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
    
    static NSString* identifier = @"teacherCells";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] init];
    }
    
    UIListContentConfiguration* configuration = [UIListContentConfiguration valueCellConfiguration];
    
    Teacher* teacher = [self.fetchedResultController objectAtIndexPath:indexPath];
    
    configuration.text = [NSString stringWithFormat:@"%@ %@",teacher.firstName, teacher.lastName];
    configuration.secondaryText = [NSString stringWithFormat:@"Cources count = %d",(int)[teacher.cources count]];
    
    if ([teacher isEqual:self.chosenTeacher]) {
        
        configuration.image = [UIImage systemImageNamed:@"checkmark"];
        configuration.imageProperties.tintColor = [UIColor blackColor];
    }
    
    cell.contentConfiguration = configuration;
    
    return cell;
}


-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

#pragma mark - UITableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Teacher* teacher = [self.fetchedResultController objectAtIndexPath:indexPath];
    
    if (self.chosenTeacher == nil || ![self.chosenTeacher isEqual:teacher]) {
        
        self.chosenTeacher = teacher;
        
    }else  {
        
        self.chosenTeacher = nil;
    }
    
    [self.tableView reloadData];
}

#pragma mark - Actions

-(void) actionBack:(UIBarButtonItem*) sender {
    
    self.currentCource.teacher = self.chosenTeacher;
    [self.persistentContainer.viewContext save:nil];
    [self reloadAllViewControllers];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
