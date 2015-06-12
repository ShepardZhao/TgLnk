//
//  UserIDRegisterTableViewController.h
//  TgLnk
//
//  Created by shepard zhao on 22/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SysNsObject.h"
#import "SystemUIViewControllerModel.h"
#import "MBProgressHUD.h"
#import "WebServicesNsObject.h"

@interface UserIDRegisterTableViewController : UITableViewController<UITextFieldDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>
@property (strong,nonatomic) NSArray *advisedUserIDArray;
@property (weak,nonatomic) MBProgressHUD *HUD;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *uniqueIndictor;
@property (weak, nonatomic) IBOutlet UIImageView *uniqueIndictorImage;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *finalRegister;

//register items;
@property (strong,nonatomic) NSString *userEmail;
@property (strong,nonatomic) NSString *userFullNmae;
@property (strong,nonatomic) NSString *userPass;
@property (weak,nonatomic) IBOutlet UITextField *userIDTextField;





//static cell
@property (weak, nonatomic) IBOutlet UITableViewCell *advised_uniqueUserID_1;
@property (weak, nonatomic) IBOutlet UITableViewCell *advised_uniqueUserID_2;
@property (weak, nonatomic) IBOutlet UITableViewCell *advised_uniqueUserID_3;
@property (weak, nonatomic) IBOutlet UITableViewCell *advised_uniqueUserID_4;

@end
