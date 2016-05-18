//
//  Dose+CoreDataProperties.h
//  MedicationLog
//
//  Created by Morgan Davison on 5/17/16.
//  Copyright © 2016 Morgan Davison. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Dose.h"

NS_ASSUME_NONNULL_BEGIN

@interface Dose (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *amount;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSManagedObject *medication;

@end

NS_ASSUME_NONNULL_END
