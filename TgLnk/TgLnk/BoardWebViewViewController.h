//
//  BoardWebViewViewController.h
//  TgLnk
//
//  Created by shepard zhao on 12/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemUIViewControllerModel.h"
#import "UIViewController+ScrollingNavbar.h"
#import "MJRefresh.h"
#import "BoardPostTableViewController.h"
#import "DatabaseModel.h"
#import "SysNsObject.h"
#import "LoginViewController.h"



@interface BoardWebViewViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate>{
    SystemUIViewControllerModel *sysUICtr;
    NSURLRequest *requestLoad;
}

@property (weak,nonatomic) NSString *address;
@property (weak, nonatomic) IBOutlet UIWebView *qrWebView;
@property DatabaseModel *db;
@end
