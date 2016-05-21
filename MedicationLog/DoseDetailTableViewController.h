//
//  DoseDetailTableViewController.h
//  MedicationLog
//
//  Created by Morgan Davison on 5/13/16.
//  Copyright © 2016 Morgan Davison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MedicationsTableViewController.h"
#import "CoreDataStack.h"

// Define protocol
@class DoseDetailTableViewController;
@protocol DoseDetailTableViewControllerDelegate <NSObject>
- (void)DoseDetailTableViewController:(DoseDetailTableViewController *)controller DidFinishWithMedications:(NSArray *)medications;
@end

@interface DoseDetailTableViewController : UITableViewController <MedicationsTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) CoreDataStack *coreDataStack;
@property (weak, nonatomic) id <DoseDetailTableViewControllerDelegate> delegate;

-(IBAction)cancelled:(id)sender;
-(IBAction)saved:(id)sender;

@end
