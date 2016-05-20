//
//  MedicationDetailTableViewController.h
//  MedicationLog
//
//  Created by Morgan Davison on 5/18/16.
//  Copyright © 2016 Morgan Davison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Medication.h"
#import "CoreDataStack.h"

@interface MedicationDetailTableViewController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) CoreDataStack *coreDataStack;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) Medication *medicationToEdit;


-(IBAction)cancel:(id)sender;
-(IBAction)save:(id)sender;

@end
