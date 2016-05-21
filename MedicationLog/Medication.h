//
//  Medication.h
//  MedicationLog
//
//  Created by Morgan Davison on 5/17/16.
//  Copyright © 2016 Morgan Davison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreDataStack.h"

@class Dose;

NS_ASSUME_NONNULL_BEGIN

@interface Medication : NSManagedObject

@property (strong, nonatomic) CoreDataStack *coreDataStack;

- (instancetype) initWithCoreDataStack:(CoreDataStack *) coreDataStack;
- (NSFetchedResultsController *) getFetchedResultsController;
- (NSArray *)getAll;
- (Medication *)getMedicationObjectForName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END

#import "Medication+CoreDataProperties.h"
