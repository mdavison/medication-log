//
//  DoseDetailTableViewController.m
//  MedicationLog
//
//  Created by Morgan Davison on 5/13/16.
//  Copyright © 2016 Morgan Davison. All rights reserved.
//

#import "DoseDetailTableViewController.h"
#import "Dose.h"
#import "MedicationsTableViewController.h"
#import "DoseDetailMedicationTableViewCell.h"
#import "DatePickerTableViewCell.h"
#import "Medication.h"

@interface DoseDetailTableViewController ()

@property (strong, nonatomic) NSArray *medicationsArray;
@property (strong, nonatomic) NSMutableDictionary *medicationsDoses;
@property (weak, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) Medication *medication;

@end

@implementation DoseDetailTableViewController

NSString *datePickerCellReuseIdentifier = @"DatePickerCell";
NSString *doseDetailMedicationCellReuseIdentifier = @"DoseDetailMedicationCell";
NSString *manageMedicationsCellReuseIdentifier = @"ManageMedications";
NSString *manageMedicationsSegueIdentifier = @"ManageMedications";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.medication = [[Medication alloc] initWithCoreDataStack:self.coreDataStack];

    [self setMedicationsArray];
    [self setMedicationsDoses];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return self.medicationsArray.count;
        case 2:
            return 1;
        default:
            return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch ([indexPath section]) {
        case 0: {
            DatePickerTableViewCell *cell = (DatePickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:datePickerCellReuseIdentifier forIndexPath:indexPath];
            self.datePicker = cell.datePicker;
            return cell;
        }
        case 1: {
            DoseDetailMedicationTableViewCell *cell = (DoseDetailMedicationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:doseDetailMedicationCellReuseIdentifier forIndexPath:indexPath];
            NSString *medicationNameForCell = [self.medicationsArray[indexPath.row] name];
            cell.textLabel.text = medicationNameForCell;
            cell.detailTextLabel.text = @" ";
            
            return cell;
        }
        case 2:
            return [tableView dequeueReusableCellWithIdentifier:manageMedicationsCellReuseIdentifier forIndexPath:indexPath];
        default:
            return [tableView dequeueReusableCellWithIdentifier:manageMedicationsCellReuseIdentifier forIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Only for medications section
    if (indexPath.section == 1) {
        self.saveButton.enabled = YES;
        
        // Get the selected cell
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        // Get the medication from the selected row
        NSString *medicationNameForCell = [self.medicationsArray[indexPath.row] name];
        
        int incrementedValue = 0;
        
        if (self.medicationsDoses[medicationNameForCell] == [NSNumber numberWithInt:0] ) { // first time incrementing
            incrementedValue = 1;
        } else { // add to existing increment
            incrementedValue = [self.medicationsDoses[medicationNameForCell] intValue] + 1;
        }
        
        self.medicationsDoses[medicationNameForCell] = [NSNumber numberWithInt:incrementedValue];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", incrementedValue];

        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


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

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *button = [UITableViewRowAction
        rowActionWithStyle:UITableViewRowActionStyleDefault
        title:@"Clear"
        handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                        
            // Get the selected cell
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            // Get the medication name
            NSString *selectedMedication = [self.medicationsArray[indexPath.row] name];
            
            self.medicationsDoses[selectedMedication] = 0;
            cell.detailTextLabel.text = @" ";
            [self.tableView setEditing:NO];
            [self enableOrDisableSaveButton];
    }];
    
    button.backgroundColor = [UIColor orangeColor];

    return [[NSArray alloc] initWithObjects:button, nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([indexPath section]) {
        case 0: // Make the row for the date picker bigger
            return 217;
        default:
            return UITableViewAutomaticDimension;
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:manageMedicationsSegueIdentifier]) {
        MedicationsTableViewController *controller = (MedicationsTableViewController *)[segue destinationViewController];
        
        controller.coreDataStack = self.coreDataStack;
        controller.delegate = self;
    }
}


#pragma mark - Actions

- (IBAction)cancelled:(id)sender {
    // Call delegate method, pass in medicationsArray
    [self.delegate DoseDetailTableViewController:self DidFinishWithMedications:self.medicationsArray];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saved:(id)sender {    
    // Save each item in medicationsDoses as a separate dose
    for (NSString *medicationName in self.medicationsDoses) {
        NSNumber *medicationQuantity = [self.medicationsDoses objectForKey:medicationName];
        
        if ([medicationQuantity intValue] > 0) {
            Medication *medication = [self.medication getMedicationObjectForName:medicationName];
            
            if (medication != nil) {
                Dose *newDose = [NSEntityDescription insertNewObjectForEntityForName:@"Dose" inManagedObjectContext:self.coreDataStack.managedObjectContext];
                newDose.amount = medicationQuantity;
                newDose.date = self.datePicker.date;
                newDose.medication = medication;
            }
        }
    }
    
    [self.coreDataStack saveContext];
    
    // Call delegate method, pass in medicationsArray
    [self.delegate DoseDetailTableViewController:self DidFinishWithMedications:self.medicationsArray];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - MedicationsTableViewControllerDelegate

- (void)medicationsTableViewControllerDidUpdate:(MedicationsTableViewController *)controller {
    [self setMedicationsArray];
    [self setMedicationsDoses];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:true];
}


#pragma mark - Helper Methods

- (void)setMedicationsArray {
    self.medicationsArray = [self.medication getAll];
}

- (void)setMedicationsDoses { 
    // Add all medications to medicationsDoses dictionary and
    // set initial value to 0
    self.medicationsDoses = [NSMutableDictionary dictionary];
    
    for (Medication *medication in self.medicationsArray) {
        self.medicationsDoses[medication.name] = [NSNumber numberWithInt:0];
    }
}

- (void)enableOrDisableSaveButton {
    // Disable it to start
    self.saveButton.enabled = NO;
    
    // If there are any items still in medicationsDoses, re-enable it
    for (NSString *medicationName in self.medicationsDoses) {
        if (self.medicationsDoses[medicationName] > [NSNumber numberWithInteger:0]) {
            self.saveButton.enabled = YES;
            return;
        }
    }
}


@end
