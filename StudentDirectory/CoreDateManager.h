//
//  CoreDateManager.h
//  StudentDirectory
//
//  Created by NEXTAcademy on 3/28/17.
//  Copyright © 2017 ArchieApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDateManager : NSObject
+(instancetype)shared;
- (NSManagedObjectContext *) managedObjectContext;

@end
