//
//  ForgetPasswordTableViewController.m
//  TgLnk
//
//  Created by Zhao, Shepard(AWF) on 6/28/15.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "ForgetPasswordTableViewController.h"

@interface ForgetPasswordTableViewController ()

@end

@implementation ForgetPasswordTableViewController


-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    

}


- (IBAction)close:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.emailAddressText becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Forget Password";
    self.tableView.tableFooterView = [[UITableView alloc] initWithFrame:CGRectZero];
    [SystemUIViewControllerModel
     hideBottomHairline:self.navigationController.navigationBar];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}


#pragma mark - UITextView delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 0 &&  textField.returnKeyType == UIReturnKeyNext) {
        if ([SysNsObject getEmailCheckRegularExpression:textField.text]) {
            [self requestCodeValidation];
        }
        else{
            [SystemUIViewControllerModel aLertViewDisplay:@"This is not a email address, please input correct one! ":@"Notices!" :self :nil :@"Try it again"];

        }

    }
    else if(textField.tag == 1 && textField.returnKeyType == UIReturnKeyDone){
        //here to reset the password
        [self codeValidation];
    }

    return YES;
}



-(void)codeValidation{
    
    [WebServicesNsObject
     POST_HTTP_METHOD:RESETPASSWORD:@{
                                        @"email" : self.emailAddressText.text,
                                        @"validateCode" :self.validateText.text
                                              }:0
     onCompletion:^(NSDictionary *getReuslt) {
         
         if ([getReuslt[@"success"] isEqualToString:@"true"]) {
             
             [self performSegueWithIdentifier:@"resetPasswordSegue" sender:self];
         }
         else if([getReuslt[@"success"] isEqualToString:@"false"]){
             
             [SystemUIViewControllerModel aLertViewDisplay:getReuslt[@"message"] :@"Notices!" :self :nil :@"Try it again"];

         }
     }];

}



/**
 * request code validation
 */
-(void)requestCodeValidation{
    
    [WebServicesNsObject
     GET_HTTP_METHOD:RESETPASSWORD:@{
                                       @"email" : self.emailAddressText.text
                                       }:0
     onCompletion:^(NSDictionary *getReuslt) {
     
         if ([getReuslt[@"success"] isEqualToString:@"true"]) {
             
             [SystemUIViewControllerModel aLertViewDisplay:getReuslt[@"message"] :@"Notices!" :self :nil :@"Got it"];
             [self.validateText becomeFirstResponder];
         }

     
     }];

}







#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PrepareToResetPasswordTableViewController *preCtl = (PrepareToResetPasswordTableViewController *)segue.destinationViewController;
    
    preCtl.userEmail = self.emailAddressText.text;
    



}


@end
