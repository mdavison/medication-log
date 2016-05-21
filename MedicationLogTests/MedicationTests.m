//
//  MedicationTests.m
//  MedicationLog
//
//  Created by Morgan Davison on 5/21/16.
//  Copyright © 2016 Morgan Davison. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Medication.h"
#import "CoreDataStack.h"

@interface MedicationTests : XCTestCase

@property (nonatomic) Medication *medicationModelToTest;
@property (nonatomic) CoreDataStack *coreDataStack;
@property (nonatomic) NSString *modelName;

@end

@implementation MedicationTests

- (void)setUp {
    [super setUp];
    
    self.coreDataStack = [[CoreDataStack alloc] init];
    self.medicationModelToTest = [[Medication alloc] initWithCoreDataStack:self.coreDataStack];
    self.modelName = @"Medication";
    
    // Add some medications to the database
    Medication *medication1 = [NSEntityDescription insertNewObjectForEntityForName:self.modelName
                                                           inManagedObjectContext:self.coreDataStack.managedObjectContext];
    medication1.name = @"Medication1";
    
    Medication *medication2 = [NSEntityDescription insertNewObjectForEntityForName:self.modelName
                                                              inManagedObjectContext:self.coreDataStack.managedObjectContext];
    medication2.name = @"Medication2";
    
    Medication *medication3 = [NSEntityDescription insertNewObjectForEntityForName:self.modelName
                                                            inManagedObjectContext:self.coreDataStack.managedObjectContext];
    medication3.name = @"Medication3";
    
    [self.coreDataStack saveContext];
    
}

- (void)tearDown {
    // Delete all medications from database
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:self.modelName];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    [self.coreDataStack.persistentStoreCoordinator executeRequest:delete withContext:self.coreDataStack.managedObjectContext error:&deleteError];
    // No need to call saveContext
    
    [super tearDown];
}

- (void)testGetMedicationObjectForName {
    Medication *medication = [self.medicationModelToTest getMedicationObjectForName:@"Medication2"];
    
    XCTAssertEqualObjects(@"Medication2", medication.name, @"The expected medication name did not match");
}

- (void)testGetAll {
    NSArray *allMedications = [self.medicationModelToTest getAll];
    
    // Count should be 3
    XCTAssertEqual(3, allMedications.count);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
