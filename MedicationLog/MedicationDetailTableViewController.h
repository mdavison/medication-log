//
//  MedicationDetailTableViewController.h
//  MedicationLog
//
//  Created by Morgan Davison on 5/18/16.
//  Copyright © 2016 Morgan Davison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface MedicationDetailTableViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

-(IBAction)cancel:(id)sender;
-(IBAction)save:(id)sender;

@end
