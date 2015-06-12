//
//  LoginViewController.h
//  TgLnk
//
//  Created by shepard zhao on 9/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterTableViewController.h"
#import "SystemUIViewControllerModel.h"
#import "MBProgressHUD.h"
#import "NsUserDefaultModel.h"
#import "DatabaseModel.h"

@protocol LoginViewControllerDelegate <NSObject>

-(void)loginDismissed;

@end

@interface LoginViewController : UIViewController<MBProgressHUDDelegate>{
   __unsafe_unretained id<LoginViewControllerDelegate> delegate;
}
@property(nonatomic,assign)id delegate;
@property (weak, nonatomic) IBOutlet UITextField *loginEmailText;
@property (weak, nonatomic) IBOutlet UITextField *loginPassText;
@property (weak,nonatomic) MBProgressHUD *HUD;
@end
