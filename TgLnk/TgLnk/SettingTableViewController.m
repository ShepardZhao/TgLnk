//
//  SettingTableViewController.m
//  TgLnk
//
//  Created by shepard zhao on 9/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "SettingTableViewController.h"

@interface SettingTableViewController (){
    NSDictionary *userQuery;
    BOOL actionStatus;
}

@end

@implementation SettingTableViewController



-(void)loginDismissed{
    if ([DatabaseModel queryUserLoginStatus]) {
        
        userQuery = [DatabaseModel queryUserInfo];
        
        self.userName.text = userQuery[@"UNICKNAME"];
        self.userID.text = [NSString stringWithFormat:@"User ID: %@",userQuery[@"UID"]];
        //use once dispatch
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [SystemUIViewControllerModel imageCache:self.userAvatar :userQuery[@"UAVATAR"]:1];
        });
        
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    userQuery = [DatabaseModel queryUserInfo];
    
    //if currently there is not user login
    if (![DatabaseModel queryUserLoginStatus]) {
        //if the current is guest login
        self.userName.text = @"Guest";
        self.userID.text = @"No login";
        self.userAvatar.image = [UIImage imageNamed:@"Avatar"];
        if (!actionStatus) {
            [self performSegueWithIdentifier:@"loginAndSegue" sender:self];
        }
    }
    else{
        self.userName.text = userQuery[@"UNICKNAME"];
        self.userID.text = [NSString stringWithFormat:@"User ID: %@",userQuery[@"UID"]];
        [SystemUIViewControllerModel imageCache:self.userAvatar :userQuery[@"UAVATAR"]:1];

    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    actionStatus = YES;

    self.userAvatar = [SystemUIViewControllerModel circleImage:self.userAvatar :0];
    [SystemUIViewControllerModel hideBottomHairline:self.navigationController.navigationBar];

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
    
    if ([segue.identifier isEqualToString:@"personalSettingSegue"]) {
        PersonalDetailSettingsTableViewController *perCtl = (PersonalDetailSettingsTableViewController *)segue.destinationViewController;
        perCtl.navTitle = userQuery[@"UNICKNAME"];
    }


}





@end
