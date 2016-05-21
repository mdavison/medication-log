//
//  Dose.m
//  MedicationLog
//
//  Created by Morgan Davison on 5/17/16.
//  Copyright © 2016 Morgan Davison. All rights reserved.
//

#import "Dose.h"
#import "CoreDataStack.h"

@implementation Dose

@synthesize coreDataStack = _coreDataStack;

- (instancetype)initWithCoreDataStack:(CoreDataStack *)coreDataStack {
    _coreDataStack = coreDataStack;
    
    return self;
}

-(NSFetchedResultsController *) getFetchedResultsController {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Dose" inManagedObjectContext:self.coreDataStack.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Relationship paths for prefetching
    fetchRequest.relationshipKeyPathsForPrefetching = [NSArray arrayWithObject:@"medication"];
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.coreDataStack.managedObjectContext sectionNameKeyPath:nil cacheName:nil];    
}

@end
