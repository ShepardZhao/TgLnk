//
//  RegisterTableViewController.m
//  TgLnk
//
//  Created by shepard zhao on 19/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "RegisterTableViewController.h"

@interface RegisterTableViewController () {
  UITapGestureRecognizer *gestureRecognizer;
    BOOL waitforValidtaionSuccessed;
}
@end

@implementation RegisterTableViewController
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.nameTextField becomeFirstResponder];

}



- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {

  [super viewWillAppear:animated];
    [self.nextStep setEnabled:NO];
    [self setTitle:@"Step One"];
}

- (void)viewWillDisappear:(BOOL)animated {

  [super viewWillDisappear:animated];
  [self triggerHideKeyBoard];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self triggerHideKeyBoard];
  [SystemUIViewControllerModel
      hideBottomHairline:self.navigationController.navigationBar];
    self.emialIndicator.hidden = YES;
}

- (void)triggerHideKeyBoard {
  gestureRecognizer =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(hideKeyboard:)];
  gestureRecognizer.cancelsTouchesInView = NO;

  [self.tableView addGestureRecognizer:gestureRecognizer];
}

- (void)hideKeyboard:(UIGestureRecognizer *)tapGestureRecognizer {
  if (!CGRectContainsPoint(
          [self.tableView
              cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]]
              .frame,
          [tapGestureRecognizer locationInView:self.tableView])) {
    [self.view endEditing:YES];
  }
}

- (IBAction)nextStep:(id)sender {
    [self performNextStep];
}

-(void)performNextStep{

    if (waitforValidtaionSuccessed) {
        [self performSegueWithIdentifier:@"userIDSegue" sender:self];
    }
    else{
        [SystemUIViewControllerModel aLertViewDisplay:@"Please waiting for Email validation!":@"Notices":self:@"OK":nil];
    }

}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


#pragma mark - textField operation 

-(void)textFieldDidBeginEditing:(UITextField *)textField{

    if (textField.tag ==1) {
        self.emialIndicator.hidden = YES;
        [self.emailCheck setHidden:YES];
        waitforValidtaionSuccessed = NO;
        
    }


}


-(void)textFieldDidEndEditing:(UITextField *)textField{

    if (textField.tag ==1 && ![textField.text isEqualToString:@""]) {
        self.emialIndicator.hidden = NO;
        [self.emialIndicator startAnimating];
    
            [WebServicesNsObject
             GET_HTTP_METHOD:
             USER_EMAIL_CHECK:@{
                                @"emailAddress" : textField.text//email check
                                }:0 onCompletion:^(NSDictionary *getReuslt) {
                                    NSLog(@"%@",getReuslt);
                                    [self.emialIndicator stopAnimating];
                                    self.emialIndicator.hidden = YES;
                                    
                                    if ([getReuslt[@"success"] isEqualToString:@"true"]) {
                                        [self.emailCheck setImage:[UIImage imageNamed:@"check"]];
                                        self.emailCheck.hidden = NO;
                                        waitforValidtaionSuccessed =YES;
                                    }
                                    else{
                                        [self.emailCheck setImage:[UIImage imageNamed:@"checkErr"]];
                                        self.emailCheck.hidden = NO;

                                    }
                                }];
    
        }
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
   [self textAction:textField];

    return YES;
}

- (void)textAction:(UITextField *)textField{
    if (textField.tag==0 && textField.returnKeyType == UIReturnKeyNext) {
        if ([self.nameTextField.text isEqualToString:@""]) {
            [SystemUIViewControllerModel aLertViewDisplay:@"The Full name is empty":@"Notices":self:@"OK":nil];
            [self.nameTextField becomeFirstResponder];
            
        }else{
            [self.emailTextField becomeFirstResponder];
        }
    }
    else if (textField.tag==1 && textField.returnKeyType == UIReturnKeyNext){
        if ([self.emailTextField.text isEqualToString:@""] ) {
            [SystemUIViewControllerModel aLertViewDisplay:@"The Email is empty":@"Notices":self:@"OK":nil];
            [self.emailTextField becomeFirstResponder];
        }else{
            if (![SysNsObject
                  getEmailCheckRegularExpression:textField.text]) {
                [SystemUIViewControllerModel aLertViewDisplay:@"This is not an email address":@"Notices":self:@"OK":nil];
                [self.emailTextField becomeFirstResponder];
            }
            else{
                [self.password_f_TextField becomeFirstResponder];
                
            }
            
        }
    }
    else if (textField.tag==2 && textField.returnKeyType == UIReturnKeyNext){
        if ([self.password_f_TextField.text isEqualToString:@""]) {
            [SystemUIViewControllerModel aLertViewDisplay:@"The password cannot be empty":@"Notices":self:@"OK":nil];
            [self.password_f_TextField becomeFirstResponder];
        }else{
            [self.password_r_TextField becomeFirstResponder];
        }
    }
    else if(textField.tag==3 && textField.returnKeyType == UIReturnKeyDone){
        if (![self.password_r_TextField.text isEqualToString:self.password_f_TextField.text]) {
            [SystemUIViewControllerModel aLertViewDisplay:@"The password does not match":@"Notices":self:@"OK":nil];
            [self.password_r_TextField becomeFirstResponder];
        }else{
            [self.nextStep setEnabled:YES];
            [textField resignFirstResponder];
        }
        
    }
    

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  if (section == 0) {
    return 4;
  } else {
    return 0;
  }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

  if ([segue.identifier isEqualToString:@"userIDSegue"]) {
    UserIDRegisterTableViewController *uidCtr =
        (UserIDRegisterTableViewController *)segue.destinationViewController;
    uidCtr.userFullNmae = self.nameTextField.text;
    uidCtr.userEmail = self.emailTextField.text;
    uidCtr.userPass = self.password_f_TextField.text;
  }
}

@end
