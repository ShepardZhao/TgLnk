//
//  ContactSearchTableViewController.h
//  TgLnk
//
//  Created by Zhao, Shepard(AWF) on 6/17/15.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactSearchTableViewCell.h"
#import "WebServicesNsObject.h"
#import "MBProgressHUD.h"
#import "DatabaseModel.h"
#import "SystemUIViewControllerModel.h"
@interface ContactSearchTableViewController : UITableViewController<UISearchBarDelegate,MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *contactSearchBar;
@property (weak, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) NSMutableArray *searchResultDict;
@end
