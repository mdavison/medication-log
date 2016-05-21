//
//  Dose.h
//  MedicationLog
//
//  Created by Morgan Davison on 5/17/16.
//  Copyright © 2016 Morgan Davison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreDataStack.h"

NS_ASSUME_NONNULL_BEGIN

@interface Dose : NSManagedObject

@property (strong, nonatomic) CoreDataStack *coreDataStack;

-(instancetype) initWithCoreDataStack:(CoreDataStack *) coreDataStack;
-(NSFetchedResultsController *) getFetchedResultsController;

@end

NS_ASSUME_NONNULL_END

#import "Dose+CoreDataProperties.h"
