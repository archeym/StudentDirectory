//  ViewController.m
//  StudentDirectory
//
//  Created by NEXTAcademy on 3/28/17.
//  Copyright © 2017 ArchieApp. All rights reserved.
#import "ViewController.h"
#import "Student+CoreDataClass.h"
#import "CoreDateManager.h"
#import "StudentDetailViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAge;
@property (weak, nonatomic) IBOutlet UITextField *textFieldGender;
@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray* students;
@property (assign, nonatomic) NSUInteger randomNumber;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegment;
@property(weak, nonatomic) Student *genderStudents;
@property(strong, nonatomic) NSFetchedResultsController *fecthedResultController;

@end

@implementation ViewController

-(NSInteger)initRandomWithRange:(NSInteger)range andWithStart:(NSInteger)start{
    int randomNumber = arc4random_uniform(range)+start;
    return randomNumber;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.context = [[CoreDateManager shared]managedObjectContext];
    [self setupUI];
    [self setupDataWithGenderFilter:@"None"];
}
#pragma mark-SETUP
-(void)setupUI{
    [self.buttonAdd addTarget:self action:@selector(buttonAddTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

-(void)buttonAddTapped:(UIButton*) sender{
    //create an object
    //1.access app delegate
    //singleton
    [self createNewStudent];
}
-(void)createNewStudent{
//    NSManagedObjectContext *context = [[CoreDateManager shared] managedObjectContext];
    Student *aStudent = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.context];
    aStudent.name = self.textField.text;
    
    //relationship
    aStudent.teacher = self.currentTeacher;
    
    //save it to coredate
    NSError *saveError = NULL;
    [self.context save:&saveError];
    if(saveError){
        //save failed, show alert
        return;
    }
}
-(void)setupDataWithGenderFilter:(NSString*)filter{
    self.context = [[CoreDateManager shared] managedObjectContext];
    NSFetchRequest *fetchRequest = [Student fetchRequest];
    if([filter isEqualToString:@"Male"]){
        NSPredicate*predicate = [NSPredicate predicateWithFormat:@"(teacher.name == %@) AND (gender == %@)", self.currentTeacher.name, @"Male"];
        [fetchRequest setPredicate:predicate];
    }else if ([filter isEqualToString:@"Female"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(teacher.name == %@) AND (gender == %@)", self.currentTeacher.name, @"Female"];
        [fetchRequest setPredicate:predicate];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"teacher.name == %@", self.currentTeacher.name];
        [fetchRequest setPredicate:predicate];
    }
    
    // for sorting  by names name is our atribute in coredata
    NSSortDescriptor *sortDecriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDecriptor]];
    
    [NSFetchedResultsController deleteCacheWithName:nil];
    
    self.fecthedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:NULL cacheName:NULL];
    self.fecthedResultController.delegate = self;
    NSError *fetchControllerError= NULL;
    [self.fecthedResultController performFetch:&fetchControllerError];
    if (fetchControllerError) {
        
    }
    [self.tableView reloadData];
}
-(void)fetchData{
    NSFetchRequest *fetchRequest = [Student fetchRequest];
    
    //set predicate to access relationship
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"teacher.name == %@", self.currentTeacher.name];
    [fetchRequest setPredicate:predicate];
    
    //sort
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSError *fetchError = NULL;
    NSArray *fetchResults = [self.context executeFetchRequest:fetchRequest error:&fetchError];
    if (fetchError) {
        return;
    }
    self.students = fetchResults;
}

-(void)removeStudent:(Student *)student{
    [self.context deleteObject:student];
    NSError *saveError = NULL;
    [self.context save:&saveError];
    if(saveError){
        //save failed, show alert
        return;
    }
}
#pragma mark-UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return self.fecthedResultController.fetchedObjects.count;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    Student *selectedStudent=[self.fecthedResultController objectAtIndexPath:indexPath];
    [self removeStudent:selectedStudent];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StudentCell" forIndexPath:indexPath];
    Student *student = [self.fecthedResultController objectAtIndexPath:indexPath];
    if (student.age==0) {
        NSInteger randomAge = [self initRandomWithRange:30 andWithStart:16];
        student.age = randomAge;
    }
        //images need to change
        NSArray *myImages = [[NSArray alloc]initWithObjects:@"lego1", @"lego2", @"lego3",@"lego4",nil];
     if (!student.image) {
        NSInteger randomImage = [self initRandomWithRange:4 andWithStart:0];
        student.image = myImages[randomImage];
   }
    NSArray *genders= [[NSArray alloc]initWithObjects:@"Male",@"Female", nil];
    if(!student.gender){
    NSUInteger genderNumber = [self initRandomWithRange:2 andWithStart:0];
    student.gender = genders[genderNumber];
    }
    
    cell.textLabel.text = student.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Age: %hd, Gender:%@%@", student.age, @" ", student.gender];
    cell.imageView.image = [UIImage imageNamed:student.image];
  
    [self addThenClear];
    NSError *saveError = NULL;
    [self.context save:&saveError];
    if(saveError){
    }
    return cell;
}
- (void)addThenClear {
    self.textField.text = @"";
}

#pragma mark -UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Student *selectedStudent=[self.fecthedResultController objectAtIndexPath:indexPath];
   
    StudentDetailViewController *controller = (StudentDetailViewController*)[self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([StudentDetailViewController class])];
    
    controller.currentStudent = selectedStudent;
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma Make- segment Controller
- (IBAction)sortGender:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 2) {
        [self setupDataWithGenderFilter:@"Female"];
    }else if (sender.selectedSegmentIndex == 1) {
        [self setupDataWithGenderFilter:@"Male"];
    } else {
        [self setupDataWithGenderFilter:@"None"];
    }
    return;
}
#pragma mark - UITableViewDelegate

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    [self.tableView beginUpdates];
    switch (type) {
        case NSFetchedResultsChangeInsert:
        {
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
        case NSFetchedResultsChangeDelete:
        {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
        case NSFetchedResultsChangeMove:
        {
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
        }
            break;
        case NSFetchedResultsChangeUpdate:
        {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
            break;
    }
    [self.tableView endUpdates];
}

@end
