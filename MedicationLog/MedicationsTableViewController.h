//
//  MedicationsTableViewController.h
//  MedicationLog
//
//  Created by Morgan Davison on 5/18/16.
//  Copyright © 2016 Morgan Davison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class MedicationsTableViewController;
@protocol MedicationsTableViewControllerDelegate <NSObject>

- (void)medicationsTableViewControllerDidUpdate:(MedicationsTableViewController *)controller;

@end

@interface MedicationsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) id <MedicationsTableViewControllerDelegate> delegate;

@end
