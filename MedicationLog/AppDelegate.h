//
//  AppDelegate.h
//  MedicationLog
//
//  Created by Morgan Davison on 5/13/16.
//  Copyright © 2016 Morgan Davison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CoreDataStack.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CoreDataStack *coreDataStack;

@end

