//
//  createTeacherController.m
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 13.01.2022.
//

#import "createTeacherController.h"
#import "Teacher+CoreDataClass.h"
#import "allCourcesController.h"
#import "Cource+CoreDataClass.h"



@interface createTeacherController ()

@end

@implementation createTeacherController

static NSInteger numberOfFirstSectionRows = 2;
static NSInteger quanityOfAddingCells = 1;
static NSInteger numberOfAddingCells = 0;
static NSInteger numberOfFirstSection = 0;
static NSInteger numberOfSecondSection = 1;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:(UIBarButtonItemStylePlain) target:self action:@selector(actionBack:)];
    backButton.tintColor = [UIColor blackColor];
    
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:(UIBarButtonItemStylePlain) target:self action:@selector(actionSave:)];
    saveButton.tintColor = [UIColor blackColor];
    
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = saveButton;
    
    
    if (self.currentTeacher) {
        
        self.navigationItem.title = @"Edit teacher";
        
    }else {
        
        self.navigationItem.title = @"Create teacher";

        Teacher* teacher = [NSEntityDescription insertNewObjectForEntityForName:@"Teacher" inManagedObjectContext:self.persistentContainer.viewContext];
        [self.persistentContainer.viewContext save:nil];
        
        self.newestTeacher = teacher;
    }
    
    [self sortingArrayWithCources];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return numberOfFirstSectionRows;
        
    }else {
        
        return self.currentTeacher ? [self.currentTeacher.cources count] + quanityOfAddingCells: [self.newestTeacher.cources count] + quanityOfAddingCells;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    UIListContentConfiguration* conf = [UIListContentConfiguration valueCellConfiguration];
    
    if (indexPath.section == 0) {
        
        UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cell.bounds) - CGRectGetMaxX(cell.bounds) / 4, 5, 170, 35)];

        if (indexPath.row == 0) {
            
            conf.text = @"Teacher first name";
            
        }else {
            
            conf.text = @"Teacher last name";

        }
        
        [self configurationForTextFields:textField withIndexPath:indexPath];
        cell.contentConfiguration = conf;
        [cell addSubview:textField];
        return cell;
        
    }else {
        
        if (indexPath.row == 0) {
            
            conf.text = @"Add cource";
            cell.contentConfiguration = conf;
            return cell;
            
        }else {
            
            NSInteger currentIndex = indexPath.row - 1;
            
            Cource* cource = [self.arrayWithCources objectAtIndex:currentIndex];
            conf.text = @"Cource";
            conf.secondaryText = cource.name;
            conf.secondaryTextProperties.color = [UIColor blackColor];
            
            cell.contentConfiguration = conf;
            return cell;
        }
        
    }
    
    
    return cell;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == numberOfFirstSection) {
        
        return @"Teacher info";
        
    }else {
        
        return @"Cources";
    }
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSInteger currentIndex = indexPath.row - 1;
        
        Cource* cource = [self.arrayWithCources objectAtIndex:currentIndex];
        [self.persistentContainer.viewContext deleteObject:cource];
        
        NSMutableArray* array = [NSMutableArray arrayWithArray:self.arrayWithCources];
        [array removeObject:cource];
        self.arrayWithCources = array;
        
        [self.persistentContainer.viewContext save:nil];
        [self reloadAllViewControllers];
    }
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == numberOfFirstSection) {
        
        return NO;
        
    }else {
        
        if (indexPath.row == numberOfAddingCells) {
            
            return NO;
        }else {
            
            return YES;
        }
    }
    return nil;
}

#pragma mark - UITableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == numberOfSecondSection && indexPath.row == numberOfAddingCells) {
        
        allCourcesController* vc = [[allCourcesController alloc] init];
        
        vc.currentTeacher = self.currentTeacher ? self.currentTeacher: self.newestTeacher;
        vc.createTeacherControllerDelegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Supporting Methods

-(void) configurationForTextFields:(UITextField*) textField withIndexPath:(NSIndexPath*) indexPath {
    
    textField.delegate = self;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textField.borderStyle = UITextBorderStyleLine;
    
    if (indexPath.row == 0) {
        
        textField.returnKeyType = UIReturnKeyNext;
        textField.placeholder = @"Enter first name";

        
        if (self.currentTeacher) {
            
            textField.text = self.currentTeacher.firstName;
            
        }else {
            
            textField.text = self.newestTeacher.firstName;
        }
        
        self.teacherFirstNameTextField = textField;

    }else {
        
        textField.returnKeyType = UIReturnKeyDone;
        textField.placeholder = @"Enter last name";

        
        if (self.currentTeacher) {
            
            textField.text = self.currentTeacher.lastName;
            
        }else {
            
            textField.text = self.newestTeacher.lastName;
        }
        
        self.teacherLastNameTextField = textField;
        
    }
    
}

-(void) sortingArrayWithCources {
    
    NSArray* array = nil;
    
    if (self.currentTeacher) {
        
        
        array = [self.currentTeacher.cources allObjects];
        
    }else {
        
        array = [self.newestTeacher.cources allObjects];
    }
    
    NSSortDescriptor* courcesDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    self.arrayWithCources = [array sortedArrayUsingDescriptors:@[courcesDescriptor]];
}

-(void) nameForTeacherFromTextField {
    
    if (self.currentTeacher) {
        
        self.currentTeacher.firstName = self.teacherFirstNameTextField.text;
        self.currentTeacher.lastName = self.teacherLastNameTextField.text;
        
    }else {
        
        self.newestTeacher.firstName = self.teacherFirstNameTextField.text;
        self.newestTeacher.lastName = self.teacherLastNameTextField.text;
    }
    
    [self reloadAllViewControllers];
}

#pragma mark - Actions

-(void) actionBack:(UIBarButtonItem*) sender {
    
    if (self.newestTeacher) {
        
        [self.persistentContainer.viewContext deleteObject:self.newestTeacher];
        [self.persistentContainer.viewContext save:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) actionSave:(UIBarButtonItem*) sender {
    
    [self nameForTeacherFromTextField];
    [self.persistentContainer.viewContext save:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

-(void) textFieldDidEndEditing:(UITextField *)textField {
    
    [self nameForTeacherFromTextField];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.teacherFirstNameTextField]) {
        
        [self.teacherLastNameTextField becomeFirstResponder];
        
    }else {
        
        [self.teacherLastNameTextField resignFirstResponder];
    }
    
    return YES;
}

@end
