//
//  Medication+CoreDataProperties.h
//  MedicationLog
//
//  Created by Morgan Davison on 5/17/16.
//  Copyright © 2016 Morgan Davison. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Medication.h"

NS_ASSUME_NONNULL_BEGIN

@interface Medication (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Dose *> *doses;

@end

@interface Medication (CoreDataGeneratedAccessors)

- (void)addDosesObject:(Dose *)value;
- (void)removeDosesObject:(Dose *)value;
- (void)addDoses:(NSSet<Dose *> *)values;
- (void)removeDoses:(NSSet<Dose *> *)values;

@end

NS_ASSUME_NONNULL_END
