//
//  StudentDetailViewController.m
//  StudentDirectory
//
//  Created by NEXTAcademy on 3/29/17.
//  Copyright © 2017 ArchieApp. All rights reserved.
#import "StudentDetailViewController.h"
#import "CoreDateManager.h"

@interface StudentDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UISwitch *swithGender;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property(strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation StudentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.context = [[CoreDateManager shared]managedObjectContext];
    [self setupUI];
}
-(void)setupUI{
    [self.updateButton addTarget:self action:@selector(updateButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.nameTextField.text = self.currentStudent.name;
    self.ageTextField.text = [NSString stringWithFormat:@"%d",self.currentStudent.age];
    self.image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", self.currentStudent.image]];
    self.genderLabel.text = self.currentStudent.gender;
    self.textView.text = self.currentStudent.info;
}
-(void)updateButtonTapped:(UIButton*)sener{
    
        //save it to coredate
    NSError *saveError = NULL;
    self.currentStudent.name = self.nameTextField.text;
    self.currentStudent.age = [self.ageTextField.text intValue];
    self.currentStudent.image = self.currentStudent.image;
    self.currentStudent.gender = self.genderLabel.text;
    self.currentStudent.info = self.textView.text;
    [self.context save:&saveError];
    if(saveError){
        //save failed, show alert
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)switch:(id)sender {
    if([self.genderLabel.text isEqualToString:@"Male"]){
        self.genderLabel.text = @"Female";
    }else{
        self.genderLabel.text = @"Male";
    }
}
@end
