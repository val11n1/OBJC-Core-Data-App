//
//  createUserController.m
//  coreDataDz
//
//  Created by Valeriy Trusov on 29.12.2021.
//

#import "createUser.h"
#import "coreDataViewContrTableViewController.h"
#import "User+CoreDataClass.h"
#import "allCourcesController.h"



@interface createUserController () <UITextFieldDelegate>

@end

@implementation createUserController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:(UIBarButtonItemStylePlain) target:self action:@selector(actionBack:)];
    backButton.tintColor = [UIColor blackColor];
    
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:(UIBarButtonItemStylePlain) target:self action:@selector(actionSave:)];
    saveButton.tintColor = [UIColor blackColor];
    
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = saveButton;
    
    if (self.chosenUser) {
        
        self.navigationItem.title = @"Edit user";
        
    }else {
        
        self.navigationItem.title = @"Create user";
        
        User* user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.persistentContainer.viewContext];
        
        [self.persistentContainer.viewContext save:nil];
        self.newestUser = user;

    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"userCell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:identifier];
    
    if (indexPath.row < 3) {
        
    
    UIListContentConfiguration* conf = [UIListContentConfiguration cellConfiguration];
    
    conf.text = [self textForCell:indexPath];
    cell.contentConfiguration = conf;
    
    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cell.bounds) - CGRectGetMaxX(cell.bounds) / 4, 5, 170, 35)];
    
    textField.borderStyle = UITextBorderStyleLine;
    [self initializatingTextField:textField andIndexPath:indexPath];
    
    [cell.contentView addSubview:textField];
        
    }else {
        
        [self configurationForCourcesCell:cell andIndexPath:indexPath];
    }

    
    return cell;
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return NO;
        
    }else {
        
        return YES;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 3) {
        
        allCourcesController* vc = [[allCourcesController alloc] init];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Actions

-(void) actionBack:(UIBarButtonItem*) sender {
    
    if (self.newestUser) {
        
        [self.persistentContainer.viewContext deleteObject:self.newestUser];
        [self.persistentContainer.viewContext save:nil];
        [self reloadAllViewControllers];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) actionSave:(UIBarButtonItem*) sender {
    
    if (self.chosenUser) {
        
        
        self.chosenUser.firstName = self.firstNameTextField.text;
        self.chosenUser.lastName = self.lastNameTextField.text;
        self.chosenUser.mail = self.mailTextField.text;
        
    }else {
        
    self.newestUser.firstName = self.firstNameTextField.text;
        self.newestUser.lastName = self.lastNameTextField.text;
        self.newestUser.mail = self.mailTextField.text;
        
    }
    
    NSError* error = nil;
    
    if (![self.persistentContainer.viewContext save:&error]) {
        
        NSLog(@"%@",[error localizedDescription]);
    }

    [self reloadAllViewControllers];
    [self.navigationController popToRootViewControllerAnimated:YES];

}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.firstNameTextField]) {
        
        [self.lastNameTextField becomeFirstResponder];
        
    }else if ([textField isEqual:self.lastNameTextField]) {
        
        [self.mailTextField becomeFirstResponder];
        
    }else {
        
        [self.mailTextField resignFirstResponder];
    }
    
    return YES;
}

-(void) textFieldDidEndEditing:(UITextField *)textField {
    
    if (self.chosenUser) {
        
        self.chosenUser.firstName = self.firstNameTextField.text;
        self.chosenUser.lastName = self.lastNameTextField.text;
        self.chosenUser.mail = self.mailTextField.text;
        
    }else {
        
        self.newestUser.firstName = self.firstNameTextField.text;
        self.newestUser.lastName = self.lastNameTextField.text;
        self.newestUser.mail = self.mailTextField.text;
        
    }
}

#pragma mark - Supporting Methods

-(NSString*) textForCell:(NSIndexPath*) indexPath {
    
    NSString* textForCell = nil;
    
    switch (indexPath.row) {
            
        case 0:
            
            textForCell = @"First name";
            break;
            
        case 1:
            
            textForCell = @"Last name";
            break;
            
        case 2:
            
            textForCell = @"E-mail";
            break;
            
        case 3:
            
            textForCell = @"Cources count";
            break;
    }
    
    return textForCell;
}

-(void) initializatingTextField:(UITextField*) textField andIndexPath:(NSIndexPath*) indexPath {
    
    textField.delegate = self;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.clearButtonMode = UITextFieldViewModeAlways;
    
    switch (indexPath.row) {
            
        case 0:
            
            textField.returnKeyType = UIReturnKeyNext;
            textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            textField.placeholder = @"Enter first name";
            self.firstNameTextField = textField;
            
            if (self.chosenUser) {
                
                self.firstNameTextField.text = self.chosenUser.firstName;
                
            }else {
                
                self.firstNameTextField.text = self.newestUser.firstName;
            }
            
            break;
            
        case 1:
            
            textField.returnKeyType = UIReturnKeyNext;
            textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            textField.placeholder = @"Enter last name";
            self.lastNameTextField = textField;
            
            if (self.chosenUser) {
                
                self.lastNameTextField.text = self.chosenUser.lastName;
                
            }else {
                
                self.lastNameTextField.text = self.newestUser.lastName;
            }
            
            break;
        
        case 2:
            
            textField.returnKeyType = UIReturnKeyDone;
            textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
            textField.placeholder = @"Enter E-mail ";
            self.mailTextField = textField;
            
            if (self.chosenUser) {
                
                self.mailTextField.text = self.chosenUser.mail;
            }else {
                
                self.mailTextField.text = self.newestUser.mail;
            }
            
            break;
    }
    
}


-(void) configurationForCourcesCell:(UITableViewCell*) cell andIndexPath:(NSIndexPath*) indexPath {
    
    UIListContentConfiguration* conf = [UIListContentConfiguration valueCellConfiguration];
    
    conf.text = [self textForCell:indexPath];
    
    if (self.chosenUser) {
        
        conf.secondaryText = [NSString stringWithFormat:@"%d",(int)[self.chosenUser.cources count]];

    }else {
    
    conf.secondaryText = [NSString stringWithFormat:@"%d",(int)[self.newestUser.cources count]];
    }
    
    cell.contentConfiguration = conf;
}

@end
