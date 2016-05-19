//
//  Medication.h
//  MedicationLog
//
//  Created by Morgan Davison on 5/17/16.
//  Copyright © 2016 Morgan Davison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Dose;

NS_ASSUME_NONNULL_BEGIN

@interface Medication : NSManagedObject

- (void)getAll;

@end

NS_ASSUME_NONNULL_END

#import "Medication+CoreDataProperties.h"
