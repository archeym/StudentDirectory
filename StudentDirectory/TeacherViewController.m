//
//  TeacherViewController.m
//  StudentDirectory
//
//  Created by NEXTAcademy on 3/29/17.
//  Copyright © 2017 ArchieApp. All rights reserved.
//

#import "TeacherViewController.h"
#import "Teacher+CoreDataClass.h"
#import "CoreDateManager.h"
#import "ViewController.h"

typedef NS_ENUM(NSUInteger,DataState){
    DataStateFetched,
    DataStateIntialized
};

@interface TeacherViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *teachers;
@property(strong, nonatomic)NSManagedObjectContext *context;
@property(assign, nonatomic) DataState dataState;

@end

@implementation TeacherViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        [self fetchTeachers];
        [self.tableView reloadData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataState = DataStateIntialized;
    [self setupUI];
}
#pragma mark - Actions
-(void)buttonAddTapped:(UIButton *)sender{
    //save to database
    Teacher *newTeacher =(Teacher *)[NSEntityDescription insertNewObjectForEntityForName:@"Teacher" inManagedObjectContext:self.context];
    newTeacher.name = self.textField.text;
    
    NSError *saveError = NULL;
    [self.context save:&saveError];
    if(saveError){
        NSLog(@"ErrorSave %@ | Description: %@ | Reason: %@",
        self.textField.text, saveError.localizedDescription,saveError.localizedDescription);
        return;
    }
    [self fetchTeachers];
    [self.tableView reloadData];
    
}

-(void)fetchTeachers{
    //fetch all the teachers
    NSFetchRequest *teacherFetchRequest = [Teacher fetchRequest];
    NSError *fetchError = NULL;
    NSArray *fechedObjects = [self.context executeFetchRequest:teacherFetchRequest error:&fetchError];
    if(fetchError){
        NSLog(@"ErrorFetching | Description: %@ | Reason: %@", fetchError.localizedDescription, fetchError.localizedDescription);
        return;
    }
    self.dataState = DataStateFetched;
    self.teachers = fechedObjects;
}

#pragma mark - Setup
-(void) setupUI{
    [self.buttonAdd addTarget:self action:@selector(buttonAddTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.context = [[CoreDateManager shared]managedObjectContext];
}
#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.teachers.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"TeacherCell" forIndexPath:indexPath];
    
    Teacher *teacher = self.teachers[indexPath.row];
    cell.textLabel.text = teacher.name;
    NSMutableString *allStudentsName = [@"" mutableCopy];
    for(Student*student in teacher.student){
        [allStudentsName appendFormat:@"%@; ",student.name];
    }
    cell.detailTextLabel.text = allStudentsName;
    [self addThenClear];
    return cell;
    
}
-(void)removeTeachers:(Teacher *)teacher{
    NSManagedObjectContext *context = [[CoreDateManager shared]managedObjectContext];
    [context deleteObject:teacher];
    NSError *saveError = NULL;
    [context save:&saveError];
    if(saveError){
        //save failed, show alert
        return;
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self removeTeachers:self.teachers[indexPath.row]];
    [self fetchTeachers];
    [self.tableView reloadData];
}

- (void)addThenClear {
    self.textField.text = @"";
    }
#pragma mark -UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Teacher *selectedTeacher = self.teachers[indexPath.row];
    
    ViewController *controller = (ViewController*)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ViewController class])];
    
    controller.currentTeacher = selectedTeacher;
    
    [self.navigationController pushViewController:controller animated:YES];

}
@end
