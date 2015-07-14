//
//  ForgetPasswordTableViewController.h
//  TgLnk
//
//  Created by Zhao, Shepard(AWF) on 6/28/15.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServicesNsObject.h"
#import "SystemUIViewControllerModel.h"
#import "PrepareToResetPasswordTableViewController.h"
@interface ForgetPasswordTableViewController : UITableViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailAddressText;
@property (weak, nonatomic) IBOutlet UITextField *validateText;

@end
