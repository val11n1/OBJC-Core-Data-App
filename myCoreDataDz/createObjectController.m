//
//  createObjectController.m
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 10.01.2022.
//

#import "createObjectController.h"
#import "Cource+CoreDataClass.h"
#import "Obj+CoreDataClass.h"
#import "allObjectController.h"
#import "allCourcesController.h"




@interface createObjectController ()

@end

@implementation createObjectController


static NSInteger addObjectCell = 1;
static NSInteger numberOfFirstSectionCells = 2;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:(UIBarButtonItemStylePlain) target:self action:@selector(actionBack:)];
    backButton.tintColor = [UIColor blackColor];
    
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:(UIBarButtonItemStylePlain) target:self action:@selector(actionSave:)];
    saveButton.tintColor = [UIColor blackColor];
    
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = saveButton;
    
    if (self.currentObject) {
        
        self.navigationItem.title = @"Edit object";
        
    }else {
        
        self.navigationItem.title = @"Create object";
        
        Obj* obj = [NSEntityDescription insertNewObjectForEntityForName:@"Obj" inManagedObjectContext:self.persistentContainer.viewContext];
        
        
        [self.persistentContainer.viewContext save:nil];

        self.newestObject = obj;
    }
    [self sortingArrayWithCources];
   
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return numberOfFirstSectionCells;
        
    }else {
    
    return self.currentObject ? [self.currentObject.cources count] + addObjectCell: [self.newestObject.cources count] + addObjectCell;
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    UIListContentConfiguration* configuration = [UIListContentConfiguration valueCellConfiguration];
    
    if (indexPath.section == 0) {
        
    if (indexPath.row == 0) {
        
        UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cell.bounds) - CGRectGetMaxX(cell.bounds) / 4, 5, 170, 35)];
        [self initializatingTextField:textField];
        
        configuration.text = @"Object name";
        
        cell.contentConfiguration = configuration;
        [cell addSubview:textField];
        
        return cell;
        
    }else if (indexPath.row == 1) {
        
        configuration.text = @"Cources count";
        configuration.secondaryText = self.currentObject ?
        [NSString stringWithFormat:@"%d", (int)[self.currentObject.cources count]]:
        [NSString stringWithFormat:@"%d",(int)[self.newestObject.cources count]];
        
        cell.contentConfiguration = configuration;
        return cell;
        
    }
    }else {
        
        if (indexPath.row == 0) {
            
            configuration.text = @"Add new cource";
            cell.contentConfiguration = configuration;
            return cell;
            
        }else {
            
            NSIndexPath* currentIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
            
            Cource* cource = [self.arrayWithCources objectAtIndex:currentIndexPath.row];
            
            configuration.text = @"Cource";
            configuration.secondaryText = [NSString stringWithFormat:@"%@",cource.name];
            configuration.secondaryTextProperties.color = [UIColor blackColor];
            
            cell.contentConfiguration = configuration;
            return cell;
        }
    }
    
    return cell;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString* textForHeader = nil;
    
    if (section == 0) {
        
        textForHeader = @"Object info";
        
    }else {
        
        textForHeader = @"Cources";
    }
    
    return textForHeader;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSIndexPath* currentIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
        
        Cource* cource = [self.arrayWithCources objectAtIndex:currentIndexPath.row];
        [self.currentObject removeCourcesObject:cource];
        
        NSMutableArray* array = [NSMutableArray arrayWithArray:self.arrayWithCources];
        [array removeObject:cource];
        self.arrayWithCources = array;
        
        [self.persistentContainer.viewContext save:nil];
        [self reloadAllViewControllers];
    }
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return NO;
        
    }else {
        
        if (indexPath.row == 0) {
            
            return NO;
            
        }else {
            
            return YES;
        }
    }
}

#pragma mark - UITableViewDelegate


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        allCourcesController* vc = [[allCourcesController alloc] init];
        vc.createObjectControllerDelegate = self;
        if (self.currentObject) {
            
            vc.currentObj = self.currentObject;
            
        }else {
            
            vc.currentObj = self.newestObject;
        }
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Supporting Methods

-(void) nameForObjectFromTextField {
    
    if (self.currentObject) {
        
        self.currentObject.name = self.nameOfObjectTextField.text;
        
    }else {
        
        self.newestObject.name = self.nameOfObjectTextField.text;
    }
    
    [self reloadAllViewControllers];
}

-(void) initializatingTextField:(UITextField*) textField {
    
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textField.placeholder = @"Enter object name";
    textField.borderStyle = UITextBorderStyleLine;
    
    if (self.currentObject) {
        
        textField.text = self.currentObject.name;
        
    }else {
        
        textField.text = self.newestObject.name;
    }

    self.nameOfObjectTextField = textField;
}

-(void) sortingArrayWithCources {
    
    NSArray* array = nil;
    
    if (self.currentObject) {
        
        
        array = [self.currentObject.cources allObjects];
        
    }else {
        
        array = [self.newestObject.cources allObjects];
    }
    
    NSSortDescriptor* courcesDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    self.arrayWithCources = [array sortedArrayUsingDescriptors:@[courcesDescriptor]];
}

#pragma mark - Actions

-(void) actionBack:(UIBarButtonItem*) sender {
    
    
    if (self.newestObject) {
        
        [self.persistentContainer.viewContext deleteObject:self.newestObject];
        [self.persistentContainer.viewContext save:nil];
        [self reloadAllViewControllers];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) actionSave:(UIBarButtonItem*) sender {
    
    [self nameForObjectFromTextField];
    [self.persistentContainer.viewContext save:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

-(void) textFieldDidEndEditing:(UITextField *)textField {
    
    [self nameForObjectFromTextField];
}


@end
