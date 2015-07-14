//
//  ContactTableViewController.h
//  TgLnk
//
//  Created by shepard zhao on 9/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeReaderDelegate.h"
#import "QRCodeReaderViewController.h"
#import "SystemUIViewControllerModel.h"
#import "WebViewViewController.h"
#import "SysNsObject.h"
#import "DatabaseModel.h"
#import "ContactTableViewCell.h"
#import "MBProgressHUD.h"
#import "WebServicesNsObject.h"


@interface ContactTableViewController : UITableViewController<QRCodeReaderDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>
@property (weak,nonatomic) NSString *qrAddress;
@property (retain ,nonatomic) MBProgressHUD *HUD;


@end
