//
//  SettingTermOfServicesViewController.m
//  TgLnk
//
//  Created by shepard zhao on 19/05/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "SettingTermOfServicesViewController.h"

@interface SettingTermOfServicesViewController ()

@end

@implementation SettingTermOfServicesViewController



- (IBAction)close:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [SystemUIViewControllerModel hideBottomHairline:self.navigationController.navigationBar];

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
