//
//  SettingTableViewController.m
//  TgLnk
//
//  Created by shepard zhao on 9/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "SettingTableViewController.h"

@interface SettingTableViewController ()

@end

@implementation SettingTableViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)loginDismissed{
    
    if ([DatabaseModel queryUserLoginStatus]) {
    
        NSDictionary *userQuery = [[NSDictionary alloc] init];
        userQuery = [DatabaseModel queryUserInfo];
        self.userName.text = userQuery[@"UNICKNAME"];
        self.userID.text = userQuery[@"UID"];
        
        //use once dispatch
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            // [SystemUIViewControllerModel imageCache:self.userAvatar :userQuery[@""]];
            
        });

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SystemUIViewControllerModel hideBottomHairline:self.navigationController.navigationBar];
    
    //if currently there is not user login
    if (![DatabaseModel queryUserLoginStatus]) {
        
        //if the current is guest login
        self.userName.text = @"Guest";
        self.userID.text = @"No login";
        [self performSegueWithIdentifier:@"loginAndSegue" sender:self];
    }
    else{
        NSDictionary *userQuery = [[NSDictionary alloc] init];
        userQuery = [DatabaseModel queryUserInfo];
        self.userName.text = userQuery[@"UNICKNAME"];

    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
        return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
        return 1;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (![DatabaseModel queryUserLoginStatus]) {
            //head to login window
            [self performSegueWithIdentifier:@"loginAndSegue" sender:self];
        }
        else {
            //head to personal detail setting
            [self performSegueWithIdentifier:@"personalSettingSegue" sender:self];
        }
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self performSegueWithIdentifier:@"aboutSettingSegue" sender:self];
    }
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"loginAndSegue"]) {
        LoginViewController *lognCtl = (LoginViewController *)segue.destinationViewController;
        lognCtl.delegate = self;
    }


}





@end
