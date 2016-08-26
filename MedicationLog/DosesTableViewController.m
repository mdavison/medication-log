//
//  DosesTableViewController.m
//  MedicationLog
//
//  Created by Morgan Davison on 5/13/16.
//  Copyright © 2016 Morgan Davison. All rights reserved.
//

#import "DosesTableViewController.h"
#import "DoseDetailTableViewController.h"
#import "Dose.h"
#import "DoseTableViewCell.h"

@interface DosesTableViewController ()

@property (strong, nonatomic) Dose *dose;

@end


@implementation DosesTableViewController

NSString *doseTableViewCellIdentifier = @"DoseCell";
NSString *addDoseSegueIdentifier = @"AddDose";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dose = [[Dose alloc] initWithCoreDataStack:self.coreDataStack];
    
    // Display an Edit button in the navigation bar
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    [self addNotificationObservers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DoseTableViewCell *cell = (DoseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:doseTableViewCellIdentifier forIndexPath:indexPath];
    NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [self configureCell:cell withObject:object];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath: indexPath]];
        
        [self.coreDataStack saveContext];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

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

- (void)configureCell:(DoseTableViewCell *)cell withObject:(NSManagedObject *)object {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *doseDate = [object valueForKey:@"date"];
    
    // Get the time and date portions separately
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    NSString *datePortion = [dateFormatter stringFromDate:doseDate];
    
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateFormatterNoStyle;
    NSString *timePortion = [dateFormatter stringFromDate:doseDate];
    
    NSString *medicationName = [[object valueForKey:@"medication"] name];
    NSString *doseAmount = [[object valueForKey:@"amount"] description];
    
    cell.dateLabel.text = [NSString stringWithFormat:@"%@\n%@", timePortion, datePortion];
    cell.quantityLabel.text = [NSString stringWithFormat:@"%@", doseAmount];
    cell.medicationLabel.text = [NSString stringWithFormat:@"%@", medicationName];
    
    // Draw a circle around the quantity
    CGFloat radius = cell.quantityView.frame.size.width / 2;
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(0, -5, radius * 2, radius * 2)];
    circle.backgroundColor = [UIColor colorWithRed:70.0/255.0 green:216.0/255.0 blue:36.0/255.0 alpha:1.0];
    circle.layer.cornerRadius = radius;
    circle.layer.masksToBounds = YES;
    [cell.quantityView insertSubview:circle belowSubview:cell.quantityLabel];

}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:addDoseSegueIdentifier]) {
        UINavigationController *navController = [segue destinationViewController];
        DoseDetailTableViewController *controller = (DoseDetailTableViewController *)navController.topViewController;
        
        controller.coreDataStack = self.coreDataStack;
        controller.delegate = self;
    }
    
}

#pragma mark - Helper Methods

- (void)addNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(persistentStoreCoordinatorStoresWillChange:)
                                                 name:NSPersistentStoreCoordinatorStoresWillChangeNotification
                                               object:self.coreDataStack.managedObjectContext.persistentStoreCoordinator];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(persistentStoreCoordinatorStoresDidChange:)
                                                 name:NSPersistentStoreCoordinatorStoresDidChangeNotification
                                               object:self.coreDataStack.managedObjectContext.persistentStoreCoordinator];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(persistentStoreDidImportUbiquitousContentChanges:)
                                                 name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                               object:self.coreDataStack.managedObjectContext.persistentStoreCoordinator];
}


#pragma mark - Notification handling

- (void)persistentStoreCoordinatorStoresWillChange:(NSNotification*)notification {
    NSLog(@"persistentStoreCoordinatorStoresWillChange");
    // Disable UI 
    [self.view setUserInteractionEnabled:NO];
    [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    
    if ([self.coreDataStack.managedObjectContext hasChanges]) {
        [self.coreDataStack saveContext];
    } else {
        dispatch_async( dispatch_get_main_queue(), ^{
            [self.coreDataStack.managedObjectContext reset];
            
            _fetchedResultsController=nil;
            [self fetchedResultsController];
        });
    }
}

- (void)persistentStoreCoordinatorStoresDidChange:(NSNotification*)notification {
    NSLog(@"persistentStoreCoordinatorStoresDidChange");
    // Re-enable UI
    [self.view setUserInteractionEnabled:YES];
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    
    [self.tableView reloadData];
}

- (void) persistentStoreDidImportUbiquitousContentChanges:(NSNotification*)notification {
    NSLog(@"persistentStoreDidImportUbiquitousContentChanges in controller");
    [self.tableView reloadData];
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchedResultsController *aFetchedResultsController = [self.dose getFetchedResultsController];
    
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unable to perform fetch for Dose %@, %@", error, [error userInfo]);
        
        // Alert user
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:[NSString localizedStringWithFormat:@"%@", @"Error"]
                                              message:[NSString localizedStringWithFormat:@"%@", @"There was a problem loading your data."]
                                              preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //abort(); // Could abort here if need to generate crash log
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withObject:anObject];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */


#pragma mark - DoseDetailTableViewControllerDelegate

- (void)DoseDetailTableViewController:(DoseDetailTableViewController *)controller DidFinishWithMedications:(NSArray *)medications {
    [self.tableView reloadData];
}


@end
