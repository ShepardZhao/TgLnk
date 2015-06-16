//
//  AccountManagementTableViewController.h
//  TgLnk
//
//  Created by Shepard zhao on 14/06/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemUIViewControllerModel.h"
#import "DatabaseModel.h"
#import "MBProgressHUD.h"
#import "WebServicesNsObject.h"

@interface AccountManagementTableViewController : UITableViewController<UITextFieldDelegate,MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userEmail;
@property (weak, nonatomic) IBOutlet UITextField *userPhone;
@property (strong, nonatomic) NSDictionary *userQuery;
@property (retain, nonatomic) MBProgressHUD *HUD;

@end
