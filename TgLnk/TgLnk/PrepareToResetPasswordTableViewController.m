//
//  PrepareToResetPasswordTableViewController.m
//  TgLnk
//
//  Created by Zhao, Shepard(AWF) on 7/14/15.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "PrepareToResetPasswordTableViewController.h"

@interface PrepareToResetPasswordTableViewController ()

@end

@implementation PrepareToResetPasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Change Password";
    [SystemUIViewControllerModel
     hideBottomHairline:self.navigationController.navigationBar];
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    [self.restPassword becomeFirstResponder];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}


#pragma mark - UITextview delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.tag ==  0 && textField.returnKeyType == UIReturnKeyNext) {
        if ([textField.text isEqualToString:@""]) {
            [SystemUIViewControllerModel aLertViewDisplay:@"The area cannot be empty!" :@"Notices!" :self :nil :@"Ok"];

        }
        else{
            [self.reinputPassword becomeFirstResponder];
        }
        
        
    }
    
    else if (textField.tag == 1 && textField.returnKeyType == UIReturnKeyDone){
        if ([self.reinputPassword.text isEqualToString:self.restPassword.text]) {
            //execute the password change
            [self executePasswordUpdating];
            
            
        }
        else{
            [SystemUIViewControllerModel aLertViewDisplay:@"Both passwords are not matching!" :@"Notices!" :self :nil :@"Ok"];
        }
    
    
    }
    
    

    return YES;
}



#pragma mark - Change the password update
-(void)executePasswordUpdating{
    

    [WebServicesNsObject
     PUT_HTTP_METHOD:RESETPASSWORD:@{
                                      @"password" : [SysNsObject md5Hash:self.restPassword.text],
                                      @"email" :self.userEmail
                                      }:0
     onCompletion:^(NSDictionary *getReuslt) {
    
         if ([getReuslt[@"success"] isEqualToString:@"true"]) {
             [self performSegueWithIdentifier:@"successfullyChangedPasswordSegue" sender:self];
             
         }
         else if ([getReuslt[@"success"] isEqualToString:@"false"]){
         
             [SystemUIViewControllerModel aLertViewDisplay:getReuslt[@"message"] :@"Notices!" :self :nil :@"Ok"];


         }
     
     }];
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
