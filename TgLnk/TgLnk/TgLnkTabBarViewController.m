//
//  TgLnkTabBarViewController.m
//  TgLnk
//
//  Created by shepard zhao on 29/03/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "TgLnkTabBarViewController.h"

@interface TgLnkTabBarViewController ()

@end

@implementation TgLnkTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    //initial database
    [DatabaseModel createTables];
    // Do any additional setup after loading the view.
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
