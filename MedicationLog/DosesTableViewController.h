//
//  DosesTableViewController.h
//  MedicationLog
//
//  Created by Morgan Davison on 5/13/16.
//  Copyright © 2016 Morgan Davison. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DosesTableViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property NSMutableArray *medications;

@end
