//
//  RegisterTableViewController.h
//  TgLnk
//
//  Created by shepard zhao on 19/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServicesNsObject.h"
#import "MBProgressHUD.h"
#import "SystemUIViewControllerModel.h"
#import "SysNsObject.h"
#import "UserIDRegisterTableViewController.h"
@interface RegisterTableViewController
: UITableViewController <UITextFieldDelegate,MBProgressHUDDelegate>
@property(weak, nonatomic) NSDictionary *fetchAdvisedUserID; // get advised user id result
@property(weak,nonatomic) IBOutlet UITextField * nameTextField;
@property(weak, nonatomic) IBOutlet UITextField *emailTextField;
@property(weak, nonatomic) IBOutlet UITextField *password_f_TextField;
@property(weak, nonatomic) IBOutlet UITextField *password_r_TextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *emialIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *emailCheck;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextStep;

@end
