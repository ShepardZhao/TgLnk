//
//  SettingTableViewController.h
//  TgLnk
//
//  Created by shepard zhao on 9/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemUIViewControllerModel.h"
#import "DatabaseModel.h"
#import "LoginViewController.h"
#import "PersonalDetailSettingsTableViewController.h"

@interface SettingTableViewController : UITableViewController<LoginViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *userID;
@end
