//
//  StudentDetailViewController.h
//  StudentDirectory
//
//  Created by NEXTAcademy on 3/29/17.
//  Copyright © 2017 ArchieApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student+CoreDataClass.h"
@interface StudentDetailViewController : UIViewController
@property(strong,nonatomic) Student *currentStudent;
@end
