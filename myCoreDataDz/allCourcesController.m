//
//  allCourcesController.m
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 08.01.2022.
//

#import "allCourcesController.h"
#import <CoreData/NSEntityDescription.h>
#import "Cource+CoreDataClass.h"
#import "User+CoreDataClass.h"
#import "Obj+CoreDataClass.h"
#import "createObjectController.h"
#import "Teacher+CoreDataClass.h"




@interface allCourcesController ()

@property (strong, nonatomic) NSMutableSet* courcesForStudent;

@end

@implementation allCourcesController

@synthesize fetchedResultController = _fetchedResultController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:(UIBarButtonItemStylePlain) target:self action:@selector(actionBack:)];
    backButton.tintColor = [UIColor blackColor];
    
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:(UIBarButtonItemStylePlain) target:self action:@selector(actionSave:)];
    saveButton.tintColor = [UIColor blackColor];
    
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = saveButton;
    self.navigationItem.title = @"All cources";

    
    if (self.delegate.chosenUser) {
        
        self.courcesForStudent = [NSMutableSet setWithSet:self.delegate.chosenUser.cources];
        
    }else if (self.delegate.newestUser) {
    
    self.courcesForStudent = [NSMutableSet setWithSet:self.delegate.newestUser.cources];
        
    }else if (self.currentObj){
        
        self.courcesForStudent = [NSMutableSet setWithSet:self.currentObj.cources];
    }else {
        
        self.courcesForStudent = [NSMutableSet setWithSet:self.currentTeacher.cources];
    }
}

-(NSFetchedResultsController*) fetchedResultController {
    
    if (_fetchedResultController != nil) {
        return _fetchedResultController;
    }
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"Cource" inManagedObjectContext:self.persistentContainer.viewContext];
    
    [request setEntity:description];
    [request setFetchBatchSize:25];
    
    NSSortDescriptor* nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor* objectDescriptor = [[NSSortDescriptor alloc] initWithKey:@"obj" ascending:YES];
    
    [request setSortDescriptors:@[nameDescriptor, objectDescriptor]];
    
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
    
   static NSString* identifier = @"courceCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:identifier];
    }
    
    Cource* cource = [self.fetchedResultController objectAtIndexPath:indexPath];
    
    UIListContentConfiguration* conf = [UIListContentConfiguration valueCellConfiguration];
    
    conf.text = [NSString stringWithFormat:@"Cource: %@",cource.name];
    conf.secondaryText = [NSString stringWithFormat:@"Object:%@",cource.obj ? cource.obj.name:  @"No object"];
    
    
    if ([self.courcesForStudent containsObject:cource]) {
        
        conf.image = [UIImage systemImageNamed:@"checkmark"];
        conf.imageProperties.tintColor = [UIColor blackColor];
        
    }else if ([self.currentObj.cources containsObject:cource]) {
        
        conf.image = [UIImage systemImageNamed:@"checkmark"];
        conf.imageProperties.tintColor = [UIColor blackColor];
    }
    
    cell.contentConfiguration = conf;
    
    return cell;
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

#pragma mark - Actions

-(void) actionBack:(UIBarButtonItem*) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) actionSave:(UIBarButtonItem*) sender {
    
    
    if (self.delegate.chosenUser) {
        
        self.delegate.chosenUser.cources = self.courcesForStudent;
        
    }else if (self.delegate.newestUser){
        
        self.delegate.newestUser.cources = self.courcesForStudent;
        
    }else if (self.currentObj){
        
        self.currentObj.cources = [NSSet setWithSet:self.courcesForStudent];
        [self.createObjectControllerDelegate sortingArrayWithCources];
        
    }else {
        
        self.currentTeacher.cources = self.courcesForStudent;
    }
    
    
    [self reloadAllViewControllers];
    //[self.delegate.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Cource* cource = [self.fetchedResultController objectAtIndexPath:indexPath];
    
    if (self.currentObj) {
        
        if ([self.currentObj.cources containsObject:cource]) {
            
            [self.currentObj removeCourcesObject:cource];
            [self.courcesForStudent removeObject:cource];
            
        }else {
            
            [self.currentObj addCourcesObject:cource];
            [self.courcesForStudent addObject:cource];
        }
        
    }else if ([self.courcesForStudent containsObject:cource]) {
        
        [self.courcesForStudent removeObject:cource];
        
    }else {
        
        [self.courcesForStudent addObject:cource];

    }
    
    [self.tableView reloadData];

}

#pragma mark - Supporting Methods




@end
