//
//  AppDelegate.h
//  StudentDirectory
//
//  Created by NEXTAcademy on 3/28/17.
//  Copyright © 2017 ArchieApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)saveContext;


@end

