//
//  SuccessfullyChangedPasswordViewController.m
//  TgLnk
//
//  Created by Zhao, Shepard(AWF) on 7/14/15.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "SuccessfullyChangedPasswordViewController.h"

@interface SuccessfullyChangedPasswordViewController ()

@end

@implementation SuccessfullyChangedPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    
    
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
