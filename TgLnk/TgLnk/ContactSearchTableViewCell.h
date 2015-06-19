//
//  ContactSearchTableViewCell.h
//  TgLnk
//
//  Created by Zhao, Shepard(AWF) on 6/17/15.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemUIViewControllerModel.h"
#import "WebServicesNsObject.h"
#import "MBProgressHUD.h"
#import "DatabaseModel.h"

@interface ContactSearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contactImage;
@property (weak, nonatomic) IBOutlet UILabel *contactUsername;
@property (weak, nonatomic) IBOutlet UILabel *contactUserID;
@property (weak, nonatomic) IBOutlet UIButton *contactAddBtn;
@property (strong, nonatomic) NSDictionary *cellDictionary;
@property (weak, nonatomic) MBProgressHUD *HUD;

@end
