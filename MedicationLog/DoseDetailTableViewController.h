//
//  DoseDetailTableViewController.h
//  MedicationLog
//
//  Created by Morgan Davison on 5/13/16.
//  Copyright © 2016 Morgan Davison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoseDetailTableViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(IBAction)cancelled:(id)sender;
-(IBAction)saved:(id)sender;

@end
