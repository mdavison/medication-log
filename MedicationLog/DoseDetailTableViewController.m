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

@end

@implementation DoseDetailTableViewController

NSString *datePickerCellReuseIdentifier = @"DatePickerCell";
NSString *doseDetailMedicationCellReuseIdentifier = @"DoseDetailMedicationCell";
NSString *manageMedicationsCellReuseIdentifier = @"ManageMedications";
NSString *manageMedicationsSegueIdentifier = @"ManageMedications";



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

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
            //return (DatePickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:datePickerCellReuseIdentifier forIndexPath:indexPath];
            return cell;
        }
        case 1: {
            DoseDetailMedicationTableViewCell *cell = (DoseDetailMedicationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:doseDetailMedicationCellReuseIdentifier forIndexPath:indexPath];
            NSString *medicationNameForCell = [self.medicationsArray[indexPath.row] name];
            cell.textLabel.text = medicationNameForCell;
            
            if (self.medicationsDoses[medicationNameForCell] == [NSNumber numberWithInt:0] || self.medicationsDoses[medicationNameForCell] == nil) {
                cell.detailTextLabel.text = @" ";
            } else {
                cell.detailTextLabel.text = @"%i", [self.medicationsDoses count];
            }
            
            return cell;
        }
        case 2:
            return [tableView dequeueReusableCellWithIdentifier:manageMedicationsCellReuseIdentifier forIndexPath:indexPath];
        default:
            return [tableView dequeueReusableCellWithIdentifier:manageMedicationsCellReuseIdentifier forIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Get the selected cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // Get the medication from the selected row
    NSString *medicationNameForCell = [self.medicationsArray[indexPath.row] name];
    
    int incrementedValue = 0;
    // TODO: handle existing dose
    
    if (self.medicationsDoses[medicationNameForCell] == [NSNumber numberWithInt:0] ) { // first time incrementing
        incrementedValue = 1;
    } else { // add to existing increment
        incrementedValue = [self.medicationsDoses[medicationNameForCell] intValue] + 1;
    }
    
    self.medicationsDoses[medicationNameForCell] = [NSNumber numberWithInt:incrementedValue];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i", incrementedValue];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([indexPath section]) {
        case 0:
            return 217;
        default:
            return UITableViewAutomaticDimension;
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:manageMedicationsSegueIdentifier]) {
        // if destination view controller is embedded in navigation controller
//        UINavigationController *navController = [segue destinationViewController];
//        MedicationsTableViewController *controller = (MedicationsTableViewController *)navController.topViewController;
        
        MedicationsTableViewController *controller = (MedicationsTableViewController *)[segue destinationViewController];
        
        controller.managedObjectContext = self.managedObjectContext;
    }
}


#pragma mark - Actions

- (IBAction)cancelled:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saved:(id)sender {    
    // loop through each item in medicationsdoses
    for (NSString *medicationName in self.medicationsDoses) {
        NSNumber *medicationQuantity = [self.medicationsDoses objectForKey:medicationName];
        
        if ([medicationQuantity intValue] > 0) {
            Medication *medication = [self getMedicationObjectForName:medicationName];
            
            if (medication != nil) {
                Dose *newDose = [NSEntityDescription insertNewObjectForEntityForName:@"Dose" inManagedObjectContext:self.managedObjectContext];
                newDose.amount = medicationQuantity;
                // TODO: get date from datepicker
                //newDose.date = [NSDate date];
                newDose.date = self.datePicker.date;
                newDose.medication = medication;
            }
        }
    }
    // TODO: self.dose = newDose; ?
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error saving to CoreData: %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Helper Methods

- (void)setMedicationsArray {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Medication" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    self.medicationsArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
}

- (void)setMedicationsDoses {
    // Add all medications to medicationsDoses dictionary and
    // set initial value to 0
    self.medicationsDoses = [NSMutableDictionary dictionary];
    for (Medication *medication in self.medicationsArray) {
        self.medicationsDoses[medication.name] = [NSNumber numberWithInt:0];
    }
}

- (Medication *)getMedicationObjectForName:(NSString *)name {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Medication" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    
    NSArray *medications = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return medications.firstObject;
}


@end
