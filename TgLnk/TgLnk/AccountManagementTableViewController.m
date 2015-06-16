//
//  AccountManagementTableViewController.m
//  TgLnk
//
//  Created by Shepard zhao on 14/06/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "AccountManagementTableViewController.h"

@interface AccountManagementTableViewController (){
    UITapGestureRecognizer *gestureRecognizer;
}

@end

@implementation AccountManagementTableViewController
- (IBAction)saveContent:(id)sender {
    
    if ([self.userName.text isEqualToString:@""]) {
        [SystemUIViewControllerModel aLertViewDisplay:@"Username cannot be empty" :@"Notices" :self :nil :@"Ok"];
    }
    else if ([self.userEmail.text isEqualToString:@""]){
        [SystemUIViewControllerModel aLertViewDisplay:@"Email cannot be empty" :@"Notices" :self :nil :@"Ok"];
    }
    else{
    
        
        self.HUD = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
        self.HUD.delegate = self;
        self.HUD.labelText = @"Updating...";
        
        [WebServicesNsObject
         PUT_HTTP_METHOD:USER_INFO_UPDATE:@{
                                          @"UID" : self.userQuery[@"UID"],
                                          @"UNICKNAME" : self.userName.text,
                                          @"UEMAIL" : self.userEmail.text,
                                          @"UPHONE" : self.userPhone.text,
                                          }:0
         onCompletion:^(NSDictionary *getReuslt) {
             
             /**
              *  update success
              */
             if ([getReuslt[@"success"] isEqualToString:@"true"] && [getReuslt[@"statusCode"] isEqualToString:@"1"]) {
                 self.HUD.labelText = @"Done";
                 
                 
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     //update local database
                     [DatabaseModel createOrUpdateUserTable:[[NSDictionary alloc] initWithObjectsAndKeys:self.userQuery[@"UID"],@"UID",self.userName.text,@"UNICKNAME",self.userEmail.text,@"UEMAIL",self.userPhone.text,@"UPHONE",[NSNumber numberWithInt:1],@"LOGINSTATUS",self.userQuery[@"UAVATAR"],@"UAVATAR",self.userQuery[@"ULOGIN_TIME"],@"ULOGIN_TIME",nil]];
                     
                     [self.HUD hide:YES];
                     
                     //return to above layer
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         [self.navigationController popViewControllerAnimated:YES];
                     });
                     
                     

                 });
                 
             }
             /**
              *  if success is false and returned statusCode is 0
              */
             
             else if ([getReuslt[@"success"] isEqualToString:@"false"] && [getReuslt[@"statusCode"] isEqualToString:@"0"]){
                
                 
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [self.HUD hide:YES];
                     [self.view endEditing:YES];
                      [SystemUIViewControllerModel aLertViewDisplay:getReuslt[@"message"] :@"Alert" :self :nil :@"Ok"];
                
                 });
                 
                 

             }
             /**
              *  if success is false and returned statusCode is 3
              *
              */
             else if ([getReuslt[@"success"] isEqualToString:@"false"] && [getReuslt[@"statusCode"] isEqualToString:@"3"]){
             
                 self.HUD.labelText = getReuslt[@"message"];
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [self.HUD hide:YES];

                 
                 });
                 
             }
             
         
             
         }];
    
        
    }
    
    
    
}

- (IBAction)signOutBtn:(id)sender {
    
    if ([DatabaseModel signOutCurrentUser:self.userQuery[@"UID"]]) {
     
        self.HUD = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
        self.HUD.delegate = self;
        self.HUD.labelText = @"Sign Out ...";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.HUD.labelText = @"Done";

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.HUD hide:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
            
            
        });
    }
    else{
     [SystemUIViewControllerModel aLertViewDisplay:@"Error to SignOut" :@"Notices" :self :@"Cancel":@"Try it again"];
    }
    
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Account Management";
    self.userQuery = [DatabaseModel queryUserInfo];
    self.userName.text = self.userQuery[@"UNICKNAME"];
    self.userEmail.text = self.userQuery[@"UEMAIL"];
    self.userPhone.text = self.userQuery[@"UPHONE"];
    [self triggerHideKeyBoard];
    [SystemUIViewControllerModel hideBottomHairline:self.navigationController.navigationBar];

}



- (void)triggerHideKeyBoard {
    gestureRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(hideKeyboard:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [self.tableView addGestureRecognizer:gestureRecognizer];
}

- (void)hideKeyboard:(UIGestureRecognizer *)tapGestureRecognizer {
    if (!CGRectContainsPoint(
                             [self.tableView
                              cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]]
                             .frame,
                             [tapGestureRecognizer locationInView:self.tableView])) {
        [self.view endEditing:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 3;
    }
    else if (section == 1){
        return 1;
    }
    else if (section == 2){
        return 0;
    }
    else if (section == 3){
        return 0;
    }
    else {
        return 1;
        
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
