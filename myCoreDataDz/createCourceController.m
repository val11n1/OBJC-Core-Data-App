//
//  createCourceController.m
//  myCoreDataDz
//
//  Created by Valeriy Trusov on 06.01.2022.
//

#import "createCourceController.h"
#import "User+CoreDataClass.h"
#import "allUsersController.h"
#import "Cource+CoreDataClass.h"
#import "allObjectController.h"
#import "Obj+CoreDataClass.h"
#import "Teacher+CoreDataClass.h"
#import "allTeachersController.h"






@interface createCourceController () <UITextFieldDelegate>

@property (strong, nonatomic) NSArray* arrayOfCellText;


@end

@implementation createCourceController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayOfCellText = @[@"Name of cource",@"Name of teacher",@"Object"];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:(UIBarButtonItemStylePlain) target:self action:@selector(actionBack:)];
    backButton.tintColor = [UIColor blackColor];
    
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:(UIBarButtonItemStylePlain) target:self action:@selector(actionSave:)];
    saveButton.tintColor = [UIColor blackColor];
    
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = saveButton;
    
    if (self.currentCource) {
        
        [self sortStudentsArray];
        self.navigationItem.title = @"Edit Cource";
    }else {
        
        self.navigationItem.title = @"Create Cource";
        
        Cource* cource = [NSEntityDescription insertNewObjectForEntityForName:@"Cource" inManagedObjectContext:self.persistentContainer.viewContext];
        
            cource.name = self.nameOfCourceTextfield.text;
            cource.students = [NSSet setWithArray:self.arrayOfStudents];
        [self.persistentContainer.viewContext save:nil];
        
        self.newestCource = cource;
    }
    
}

-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    [self sortStudentsArray];
}

#pragma mark - UITableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if (indexPath.row == 0 && indexPath.section == 1) {
            
            
            allUsersController* vc = [[allUsersController alloc] init];
            
            if (self.currentCource) {
                
                self.currentCource.name = self.nameOfCourceTextfield.text;
                vc.currentCource = self.currentCource;
                
            }else {
                
                self.newestCource.name = self.nameOfCourceTextfield.text;
                vc.currentCource = self.newestCource;
            }
            
            
            vc.createCourcesContrDelegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (indexPath.section == 0 && indexPath.row == 2) {
            
            allObjectController* vc = [[allObjectController alloc] init];
            
            if (self.currentCource) {
                
                self.currentCource.name = self.nameOfCourceTextfield.text;
                vc.currentCource = self.currentCource;
                
            }else {
                
                self.newestCource.name = self.nameOfCourceTextfield.text;
                vc.currentCource = self.newestCource;
            }
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (indexPath.section == 0 && indexPath.row == 1) {
            
            allTeachersController* vc = [[allTeachersController alloc] init];
            
            if (self.currentCource) {
                
                vc.currentCource = self.currentCource;
                
            }else {
                
                vc.currentCource = self.newestCource;
            }
            
            [self.navigationController pushViewController:vc animated:YES];
        }
}

#pragma mark - Table view data source

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSIndexPath* currentIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
        
        User* user = [self.arrayOfStudents objectAtIndex:currentIndexPath.row];
        [self.currentCource removeStudentsObject:user];
        
        NSMutableArray* array = [NSMutableArray arrayWithArray:self.arrayOfStudents];
        [array removeObject:user];
        self.arrayOfStudents = array;
        
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
        }
        
        return YES;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.currentCource) {
        
        return section == 0 ? 3: [[self.currentCource students] count] + 1;
        
    }
        
    
    return section == 0 ? 3: [self.arrayOfStudents count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
    static NSString* identifier = @"courceCell";
        
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:identifier];
    
    UIListContentConfiguration* conf = [UIListContentConfiguration valueCellConfiguration];
    
        if (indexPath.row == 2) {
            
            conf = [self configurationForObjectCell];
            cell.contentConfiguration = conf;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
            
        } else if (indexPath.row == 1) {
            
            conf = [self configurationForTeacherCell];
            cell.contentConfiguration = conf;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
            
        }else {
        
    conf.text = [self.arrayOfCellText objectAtIndex:indexPath.row];
    cell.contentConfiguration = conf;
            
    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cell.bounds) - CGRectGetMaxX(cell.bounds) / 4, 5, 170, 35)];
    
    textField.borderStyle = UITextBorderStyleLine;
    [self initializatingTextField:textField];
    textField.text = [self textForCurrentTextField:textField];
    
    [cell.contentView addSubview:textField];
            
    return cell;
        
    }
        
    }else {
        
        static NSString* identifier = @"studentCourceCell";

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:identifier];
        }
        
        
        if (indexPath.row == 0) {
            
            cell.contentConfiguration = [self listContentConfigurationForCellWithText:@"Add student to cource."];
        }else {
            
            
            
            NSIndexPath* currentIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
            
            User* user = [self.arrayOfStudents objectAtIndex:currentIndexPath.row];
            
            NSString* stringForCell = [NSString stringWithFormat:@"%@ %@",user.firstName, user.lastName];
            
            cell.contentConfiguration = [self listContentConfigurationForCellWithText:stringForCell];
        }
        
        return cell;
    }
    
    return nil;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return @"Cource info";
        
    }else {
        
        return @"Students";
    }
    return nil;
}


#pragma mark - Supporting methods

-(void) initializatingTextField:(UITextField*) textField {
    
    textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    textField.placeholder = @"Enter cource name";
    
    self.nameOfCourceTextfield = textField;
}



-(UIListContentConfiguration*) listContentConfigurationForCellWithText:(NSString*) text {
    
    UIListContentConfiguration* conf = [UIListContentConfiguration cellConfiguration];
    conf.text = text;
    
    
    return conf;
}



-(NSString*) textForCurrentTextField:(UITextField*) textfield {
    
    NSString* text = nil;
    
    if (self.currentCource) {
        
        text = self.currentCource.name;

    }else {
        
        text = self.newestCource.name;
    }
    
    return text;
}

#pragma mark - Actions

-(void) actionBack:(UIBarButtonItem*) sender {
    
    if (self.newestCource) {
        
        [self.persistentContainer.viewContext deleteObject:self.newestCource];
        
        [self.persistentContainer.viewContext save:nil];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) actionSave:(UIBarButtonItem*) sender {
    
    if (self.currentCource) {
        
        self.currentCource.name = self.nameOfCourceTextfield.text;

    }else {
        
        //self.newestCource.name = self.nameOfCourceTextfield.text;
    }

    [self.persistentContainer.viewContext save:nil];
    
    [self reloadAllViewControllers];
    [self.navigationController popToRootViewControllerAnimated:YES];

}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (self.currentCource) {
        
        self.currentCource.name = textField.text;

    }else {
    
    self.newestCource.name = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.nameOfCourceTextfield]) {
        
        [self.nameOfCourceTextfield resignFirstResponder];
        
    }
    
    return YES;
}


#pragma mark - Supporting Methods



-(void) showCourceInfo {
    
    self.nameOfCourceTextfield.text = self.currentCource.name;

}

-(void) sortStudentsArray {
    
    
    if (self.currentCource) {
        
        self.arrayOfStudents = [self.currentCource.students allObjects];

    }else {
        
        self.arrayOfStudents = [self.newestCource.students allObjects];
    }
    
 self.arrayOfStudents = [self.arrayOfStudents sortedArrayUsingComparator:^NSComparisonResult(User* obj1, User* obj2) {
        
        return [obj1.firstName compare:obj2.firstName];
    }];
}

#pragma mark Cells Configuration Methods

-(UIListContentConfiguration*) configurationForTeacherCell {
    
    UIListContentConfiguration* conf = [UIListContentConfiguration valueCellConfiguration];
    
    conf.text = @"Teacher";
    
    if (self.currentCource.teacher) {
        
        conf.secondaryText = [NSString stringWithFormat:@"%@ %@", self.currentCource.teacher.firstName, self.currentCource.teacher.lastName];
        
    }else if (self.newestCource.teacher){
        
        conf.secondaryText = [NSString stringWithFormat:@"%@ %@", self.newestCource.teacher.firstName, self.newestCource.teacher.lastName];
        
    }else {
        
        conf.secondaryText = @"Chose teacher";
    }
    
    conf.secondaryTextProperties.color = [UIColor blackColor];
    
    return conf;
}

-(UIListContentConfiguration*) configurationForObjectCell {
    
    UIListContentConfiguration* conf = [UIListContentConfiguration valueCellConfiguration];
    conf.text = @"Object";

    if (self.currentCource.obj) {
        
        conf.secondaryText = self.currentCource.obj.name;
        
    }else if (self.newestCource.obj){
        
        conf.secondaryText = self.newestCource.obj.name;
        
    }else {
        
        conf.secondaryText = @"Chose object";
    }
    
    conf.secondaryTextProperties.color = [UIColor blackColor];
    return conf;
}
@end
