//
//  ViewController.h
//  StudentDirectory
//
//  Created by NEXTAcademy on 3/28/17.
//  Copyright © 2017 ArchieApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Teacher+CoreDataClass.h"
#import <CoreData/CoreData.h>
@interface ViewController : UIViewController
@property(nonatomic, strong)Teacher *currentTeacher;
@end

