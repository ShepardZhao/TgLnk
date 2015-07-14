//
//  PrepareToResetPasswordTableViewController.h
//  TgLnk
//
//  Created by Zhao, Shepard(AWF) on 7/14/15.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemUIViewControllerModel.h"
#import "SysNsObject.h"
#import "WebServicesNsObject.h"
@interface PrepareToResetPasswordTableViewController : UITableViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *restPassword;
@property (weak, nonatomic) IBOutlet UITextField *reinputPassword;
@property (strong,nonatomic) NSString *userEmail;
@end
