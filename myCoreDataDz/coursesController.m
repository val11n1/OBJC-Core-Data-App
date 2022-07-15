//
//  coursesController.m
//  coreDataDz
//
//  Created by Valeriy Trusov on 28.12.2021.
//

#import "coursesController.h"
#import "createCourceController.h"
#import "Cource+CoreDataClass.h"


@interface coursesController ()

@end

@implementation coursesController

@synthesize fetchedResultController = _fetchedResultController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Courses";
    
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"plus"] style:(UIBarButtonItemStylePlain) target:self action:@selector(actionAdd:)];
    addButton.tintColor = [UIColor blackColor];
    
    self.navigationItem.leftBarButtonItem = addButton;
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
    
    static NSString* identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:identifier];
    }
    
    UIListContentConfiguration* configuration = [UIListContentConfiguration valueCellConfiguration];
    
    configuration.text = [NSString stringWithFormat:@"Course #%d",(int)indexPath.row + 1];
    
    Cource* cource = [self.fetchedResultController objectAtIndexPath:indexPath];
    
    configuration.secondaryText = [NSString stringWithFormat:@"%@",cource.name];
    
    cell.contentConfiguration = configuration;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Actions

-(void) actionAdd:(UIBarButtonItem*) sender {
    
    createCourceController* vc = [[createCourceController alloc] init];
    self.createCourceControllerDelegate = vc;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    createCourceController* vc = [[createCourceController alloc] init];
    self.createCourceControllerDelegate = vc;
    vc.currentCource = [self.fetchedResultController objectAtIndexPath:indexPath];
    [self.navigationController pushViewController:vc animated:YES];
}

@end


