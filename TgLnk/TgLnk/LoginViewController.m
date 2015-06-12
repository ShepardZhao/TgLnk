//
//  LoginViewController.m
//  TgLnk
//
//  Created by shepard zhao on 9/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end


@implementation LoginViewController
@synthesize delegate;
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self setTitle:@"Welcome"];
  self.HUD.delegate = self;
}



-(void) loginSubmit{

    if ([self.loginEmailText.text isEqualToString:@""]) {
        [SystemUIViewControllerModel aLertViewDisplay:@"The email cannot be empty":@"Notices":self:@"OK":nil];
        
    } else if ([self.loginPassText.text isEqualToString:@""]) {
        [SystemUIViewControllerModel aLertViewDisplay:@"The password cannot be empty":@"Notices":self:@"OK":nil];
    } else {
        
        // submit login request
        self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.HUD.labelText = @"Sign in...";
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            [WebServicesNsObject
             POST_HTTP_METHOD:USER_LOGIN_URL:@{
                              @"email" : self.loginEmailText.text,
                              @"pass" : [SysNsObject md5Hash:self.loginPassText.text]
                              }:0
             onCompletion:^(NSDictionary *getReuslt) {
                 self.HUD.mode = MBProgressHUDModeText;
                 self.HUD.margin = 10.f;
                 NSLog(@"%@",getReuslt);

                 if ([getReuslt[@"success"] isEqualToString:@"true"]) {
                     
                     //save the login user information into NSDefault and sqlite db
                     
                     //call sqlite db set and created
                     NSLog(@"%@",getReuslt[@"user"]);
                     
                     
                     //[DatabaseModel createOrUpdateUserTable:getReuslt[@"user"]];
                     
                     //NSLog(@"%@",getReuslt[@"user"]);
                     //call NSDefault
                     //[NsUserDefaultModel setUserDefault:getReuslt[@"user"] :@"userInfoLibrary"];
                     
                     
                     self.HUD.labelText = @"Login Completed!";

                     [self.view endEditing:YES];
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                         
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             [self dismissViewControllerAnimated:YES completion:nil];
                             
                         });
                        
                     });
                 }
                 else if([getReuslt[@"success"] isEqualToString:@"false"] && ![getReuslt[@"message"] isEqualToString:@""]){
                     self.HUD.labelText =getReuslt[@"message"];
                     dispatch_async(dispatch_get_main_queue(), ^(void){
                         [self.HUD hide:YES afterDelay:3];
                     });

                 }
             }];
        });
    }




}


- (IBAction)Login:(id)sender {
    [self loginSubmit];
}

- (IBAction)registerBtn:(id)sender {

  [self performSegueWithIdentifier:@"registerSegue" sender:self];
}
- (IBAction)close:(id)sender {

    [self dismissViewControllerAnimated:YES completion:^(void){
        [delegate loginDismissed];
    }];
    
}
- (IBAction)userName:(id)sender {
  // self.userNameTextField.delegate = self;
}
- (IBAction)password:(id)sender {
  // self.passwordTextField.delegate =self;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [[self view] endEditing:YES];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self view] endEditing:YES];

}



- (void)viewDidLoad {
  [super viewDidLoad];

  [SystemUIViewControllerModel
      hideBottomHairline:self.navigationController.navigationBar];

  UIView *emailSpacerView = INDENT();
  UIImageView *emailIcon =
      [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Email"]];
  emailIcon.center = emailSpacerView.center;
  [emailSpacerView addSubview:emailIcon];

  [self.loginEmailText setLeftViewMode:UITextFieldViewModeAlways];
  [self.loginEmailText setLeftView:emailSpacerView];

  UIView *passSpacerView = INDENT();
  UIImageView *passIcon =
      [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Pass"]];
  passIcon.center = passSpacerView.center;
  [passSpacerView addSubview:passIcon];

  [self.loginPassText setLeftViewMode:UITextFieldViewModeAlways];
  [self.loginPassText setLeftView:passSpacerView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

#pragma mark - textfield

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.tag == 0 && textField.returnKeyType == UIReturnKeyNext) {
        [self.loginPassText becomeFirstResponder];
    }
    if (textField.tag ==1 && textField.returnKeyType == UIReturnKeyGo) {
        [textField resignFirstResponder];
        [self loginSubmit];
        
    
    }
    
    return YES;
}



/**
 *keyboard over the textfield
 **/
- (void)textFieldDidBeginEditing:(UITextField *)textField {
  [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  [self animateTextField:textField up:NO];
}

- (void)animateTextField:(UITextField *)textField up:(BOOL)up {
    int movementDistance = 110;     // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
   /*
    if ([[SysNsObject getDeviceName] isEqualToString:@"iPhone4,1"]) {
        movementDistance =40;
    }
    else if ([[SysNsObject getDeviceName] isEqualToString:@"iPhone5,1"] || [[SysNsObject getDeviceName] isEqualToString:@"iPhone5,2"]) {
        movementDistance =60;
    }
    else if ([[SysNsObject getDeviceName] isEqualToString:@"iPhone7,2"] || [[SysNsObject getDeviceName] isEqualToString:@"iPhone7,1"]) {
        movementDistance =160;
    }
    */
    
  int movement = (up ? -movementDistance : movementDistance);

  [UIView beginAnimations:@"anim" context:nil];
  [UIView setAnimationBeginsFromCurrentState:YES];
  [UIView setAnimationDuration:movementDuration];
  self.view.frame = CGRectOffset(self.view.frame, 0, movement);
  [UIView commitAnimations];
}
/**
 *end
 **/

@end
