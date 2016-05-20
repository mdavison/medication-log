//
//  MedicationDetailTableViewController.m
//  MedicationLog
//
//  Created by Morgan Davison on 5/18/16.
//  Copyright © 2016 Morgan Davison. All rights reserved.
//

#import "MedicationDetailTableViewController.h"
#import "Medication.h"

@interface MedicationDetailTableViewController ()

@end

@implementation MedicationDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.medicationToEdit != nil) {
        self.nameTextField.text = self.medicationToEdit.name;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.nameTextField resignFirstResponder];
    return true;
}


#pragma mark - Actions 

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)save:(id)sender {
    if ([self medicationNameIsValid]) {
        if (self.medicationToEdit == nil) {
            Medication *medication = [NSEntityDescription insertNewObjectForEntityForName:@"Medication"
                                                                   inManagedObjectContext:self.coreDataStack.managedObjectContext];
            medication.name = self.nameTextField.text;
        } else {
            self.medicationToEdit.name = self.nameTextField.text;
        }

        [self.coreDataStack saveContext];
        
        [self dismissViewControllerAnimated:true completion:nil];
    }
}


#pragma mark - Helper Methods

- (BOOL)medicationNameIsValid {
    // Make sure medication is not blank
    if ([self.nameTextField.text length] == 0) {
        return false;
    }
    
    // Make sure it's not blank after trimming whitespace
    NSCharacterSet *whitespaceSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedString = [self.nameTextField.text stringByTrimmingCharactersInSet:whitespaceSet];
    if ([trimmedString length] == 0) {
        [self showInvalidNameAlertWithTitle:NSLocalizedString(@"Oops!", @"") andMessage:NSLocalizedString(@"Name can't be blank.", @"")];
        self.nameTextField.text = @"";
        
        return false;
    }
    
    // Make sure medication is not duplicate
    for (Medication *medication in [self.fetchedResultsController fetchedObjects]) {
        if (self.nameTextField.text == medication.name) {
            [self showInvalidNameAlertWithTitle:NSLocalizedString(@"Oops!", @"") andMessage:NSLocalizedString(@"That name already exists.", @"")];
            self.nameTextField.text = @"";

            return false;
        }
    }
    
    return true;
}

- (void)showInvalidNameAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
