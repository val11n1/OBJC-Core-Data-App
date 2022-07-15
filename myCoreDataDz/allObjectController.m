//
//  allObjectController.m
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 11.01.2022.
//

#import "allObjectController.h"
#import <CoreData/NSEntityDescription.h>
#import "Obj+CoreDataClass.h"
#import "createCourceController.h"
#import "Cource+CoreDataClass.h"



@interface allObjectController ()

@property (strong, nonatomic) Obj* chosenObj;

@end

@implementation allObjectController

@synthesize fetchedResultController = _fetchedResultController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:(UIBarButtonItemStylePlain) target:self action:@selector(actionBack:)];
    backButton.tintColor = [UIColor blackColor];
    
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.title = @"All objects";
    
    if (self.currentCource.obj) {
        
        self.chosenObj = self.currentCource.obj;
    }
   
}

-(NSFetchedResultsController*) fetchedResultController {
    
    if (_fetchedResultController != nil) {
        return _fetchedResultController;
    }
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description = [NSEntityDescription entityForName:@"Obj" inManagedObjectContext:self.persistentContainer.viewContext];
    
    [request setEntity:description];
    [request setFetchBatchSize:25];
    
    NSSortDescriptor* nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    [request setSortDescriptors:@[nameDescriptor]];
    
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
    
    static NSString* identifier = @"cellForObj";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    

    if (!cell) {
        
        cell = [[UITableViewCell alloc] init];
    }
    
    UIListContentConfiguration* configuration = [UIListContentConfiguration valueCellConfiguration];
    
    Obj* obj = [self.fetchedResultController objectAtIndexPath:indexPath];
    
    configuration.text = [NSString stringWithFormat:@"Object #%d",(int)indexPath.row + 1];
    configuration.secondaryText = [NSString stringWithFormat:@"%@", obj.name];
    configuration.secondaryTextProperties.color = [UIColor blackColor];
    
    if ([self.chosenObj isEqual:obj]) {
        
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
    
    Obj* obj = [self.fetchedResultController objectAtIndexPath:indexPath];
    
    if (!self.chosenObj || ![self.chosenObj isEqual:obj]) {
        
        self.chosenObj = obj;
        
    }else if ([self.chosenObj isEqual:obj]) {
        
        self.chosenObj = nil;
        
    }
    [self.tableView reloadData];
    [self reloadAllViewControllers];
}

#pragma mark - Actions

-(void) actionBack:(UIBarButtonItem*) sender {
    
    self.currentCource.obj = self.chosenObj;
    [self reloadAllViewControllers];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
