//
//  Medication.m
//  MedicationLog
//
//  Created by Morgan Davison on 5/17/16.
//  Copyright © 2016 Morgan Davison. All rights reserved.
//

#import "Medication.h"
#import "Dose.h"
#import "CoreDataStack.h"

@implementation Medication

@synthesize coreDataStack = _coreDataStack;

- (instancetype)initWithCoreDataStack:(CoreDataStack *)coreDataStack {
    _coreDataStack = coreDataStack;
    
    return self;
}

- (NSFetchedResultsController *) getFetchedResultsController {
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    
    return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.coreDataStack.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (NSArray *)getAll {
    NSFetchRequest *fetchRequest = [self getFetchRequest];
    
    NSError *error = nil;
    NSArray *medications = [self.coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"Error fetching medications: %@", error);
    }
    
    return medications;
}

- (Medication *)getMedicationObjectForName:(NSString *)name {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Medication" inManagedObjectContext:self.coreDataStack.managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    
    NSError *error = nil;
    NSArray *medications = [self.coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"Error fetching medication for name: %@", error);
    }
    
    return medications.firstObject;
}

- (NSFetchRequest *)getFetchRequest {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Medication" inManagedObjectContext:self.coreDataStack.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    return fetchRequest;
}


@end
