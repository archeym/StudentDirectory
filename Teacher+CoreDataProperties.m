//
//  Teacher+CoreDataProperties.m
//  StudentDirectory
//
//  Created by NEXTAcademy on 3/30/17.
//  Copyright © 2017 ArchieApp. All rights reserved.
//

#import "Teacher+CoreDataProperties.h"

@implementation Teacher (CoreDataProperties)

+ (NSFetchRequest<Teacher *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Teacher"];
}

@dynamic name;
@dynamic subject;
@dynamic student;

@end
