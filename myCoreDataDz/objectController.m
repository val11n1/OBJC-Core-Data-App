//
//  objectController.m
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 09.01.2022.
//

#import "objectController.h"
#import <CoreData/NSEntityDescription.h>
#import "Obj+CoreDataClass.h"
#import "createObjectController.h"


@interface objectController ()

@end

@implementation objectController

@synthesize fetchedResultController = _fetchedResultController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"plus"] style:(UIBarButtonItemStylePlain) target:self action:@selector(actionAdd:)];
    addButton.tintColor = [UIColor blackColor];
    
    self.navigationItem.leftBarButtonItem = addButton;
    self.navigationItem.title = @"Objects";
    
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
    
    static NSString* identifier = @"objectIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:identifier];
    }
    
    UIListContentConfiguration* configuration = [UIListContentConfiguration valueCellConfiguration];
    
    Obj* obj = [self.fetchedResultController objectAtIndexPath:indexPath];
    
    configuration.text = @"Object";
    configuration.secondaryText = obj.name;
    configuration.secondaryTextProperties.color = [UIColor blackColor];
    
    cell.contentConfiguration = configuration;
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Obj* obj = [self.fetchedResultController objectAtIndexPath:indexPath];
    
    createObjectController* vc = [[createObjectController alloc] init];
    vc.currentObject = obj;
    self.creatingObjectContr = vc;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - Actions

-(void) actionAdd:(UIBarButtonItem*) sender {
    
   createObjectController* vc = [[createObjectController alloc] init];
    self.creatingObjectContr = vc;
    [self.navigationController pushViewController:vc animated:YES];

}



@end
