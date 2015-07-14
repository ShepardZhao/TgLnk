//
//  UserQRCodeViewController.m
//  TgLnk
//
//  Created by Zhao, Shepard(AWF) on 6/30/15.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "UserQRCodeViewController.h"

@interface UserQRCodeViewController ()

@end

@implementation UserQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SystemUIViewControllerModel imageCache:self.userQRCodeView :[DatabaseModel queryUserInfo][@"UQR_CODE"] :3];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
