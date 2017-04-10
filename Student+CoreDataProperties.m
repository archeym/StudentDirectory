//
//  Student+CoreDataProperties.m
//  StudentDirectory
//
//  Created by NEXTAcademy on 3/30/17.
//  Copyright © 2017 ArchieApp. All rights reserved.
//

#import "Student+CoreDataProperties.h"

@implementation Student (CoreDataProperties)

+ (NSFetchRequest<Student *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Student"];
}

@dynamic age;
@dynamic gender;
@dynamic image;
@dynamic info;
@dynamic name;
@dynamic teacher;

@end
