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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (self.medicationToEdit != nil) {
        self.nameTextField.text = self.medicationToEdit.name;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.nameTextField resignFirstResponder];
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    //
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Actions 

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)save:(id)sender {
    if ([self medicationNameIsValid]) {
        if (self.medicationToEdit == nil) {
            Medication *medication = [NSEntityDescription insertNewObjectForEntityForName:@"Medication"
                                                                   inManagedObjectContext:self.managedObjectContext];
            medication.name = self.nameTextField.text;
        } else {
            self.medicationToEdit.name = self.nameTextField.text;
        }
        
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Error saving to CoreData: %@, %@", error, [error userInfo]);
            abort();
        }
        
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
