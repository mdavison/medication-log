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

@interface DoseDetailTableViewController ()

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
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    [self.tableView registerClass: [DatePickerTableViewCell class] forCellReuseIdentifier:datePickerCellReuseIdentifier];
//    [self.tableView registerClass: [DoseDetailMedicationTableViewCell class] forCellReuseIdentifier:doseDetailMedicationCellReuseIdentifier];
//    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier:manageMedicationsCellReuseIdentifier];
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
    return 1;
    // TODO: section 1 returns medications count
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch ([indexPath section]) {
        case 0:
            return (DatePickerTableViewCell *)[tableView dequeueReusableCellWithIdentifier:datePickerCellReuseIdentifier forIndexPath:indexPath];
        case 1:
            return (DoseDetailMedicationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:doseDetailMedicationCellReuseIdentifier forIndexPath:indexPath];
        case 2:
            return [tableView dequeueReusableCellWithIdentifier:manageMedicationsCellReuseIdentifier forIndexPath:indexPath];
        default:
            return [tableView dequeueReusableCellWithIdentifier:manageMedicationsCellReuseIdentifier forIndexPath:indexPath];
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
    Dose *newDose = [NSEntityDescription insertNewObjectForEntityForName:@"Dose" inManagedObjectContext:self.managedObjectContext];
    newDose.amount = [NSNumber numberWithInt:1];
    newDose.date = [NSDate date];
    // TODO: newDose.medication = ?
    // TODO: self.dose = newDose;
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error saving to CoreData: %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
