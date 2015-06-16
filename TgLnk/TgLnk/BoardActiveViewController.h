//
//  BoardActiveViewController.h
//  TgLnk
//
//  Created by Shepard zhao on 15/06/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemUIViewControllerModel.h"
#import "WebServicesNsObject.h"
#import "MBProgressHUD.h"
#import "BoardDetailTableViewController.h"

@interface BoardActiveViewController : UIViewController<MBProgressHUDDelegate>

@property (strong,nonatomic) NSDictionary *boardArray;
@property (weak, nonatomic) IBOutlet UIImageView *uiboardImage;
@property (weak, nonatomic) IBOutlet UITextField *activeCodeText;
@property (weak,nonatomic) MBProgressHUD *HUD;
@end
