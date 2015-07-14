//
//  MessagesTableViewController.h
//  TgLnk
//
//  Created by shepard zhao on 29/03/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeReaderDelegate.h"
#import "QRCodeReaderViewController.h"
#import "SystemUIViewControllerModel.h"
#import "WebViewViewController.h"
#import "SysNsObject.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "QRAnalysisNSObject.h"
#import "BoardActiveViewController.h"
#import "BoardDetailTableViewController.h"

@interface MessagesTableViewController : UITableViewController<QRCodeReaderDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>
@property (weak,nonatomic) NSString *qrAddress;
@property (retain ,nonatomic) MBProgressHUD *HUD;

@end
