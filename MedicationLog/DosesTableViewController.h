//
//  DosesTableViewController.h
//  MedicationLog
//
//  Created by Morgan Davison on 5/13/16.
//  Copyright © 2016 Morgan Davison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DoseDetailTableViewController.h"
#import "CoreDataStack.h"

@interface DosesTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, DoseDetailTableViewControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) CoreDataStack *coreDataStack;

@end
