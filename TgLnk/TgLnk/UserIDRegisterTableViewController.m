//
//  UserIDRegisterTableViewController.m
//  TgLnk
//
//  Created by shepard zhao on 22/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "UserIDRegisterTableViewController.h"

@interface UserIDRegisterTableViewController () {
  BOOL isEnableAdvisedSection;
}

@end

@implementation UserIDRegisterTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    self.HUD.delegate = self;
    [SystemUIViewControllerModel hideBottomHairline:self.navigationController.navigationBar];
    [self.finalRegister setEnabled:NO];
        
}


- (IBAction)submit:(id)sender {
  self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{

      [WebServicesNsObject
           POST_HTTP_METHOD:
          REGISTER_URL:@{
            @"email" : self.userEmail,@"userFullName":self.userFullNmae,@"userPass":[SysNsObject md5Hash:self.userPass],@"userID":self.userIDTextField.text
          }:0 onCompletion:^(NSDictionary *getReuslt) {
            
            if ([getReuslt[@"success"] isEqualToString:@"true"]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self performSegueWithIdentifier:@"successRegisterSegue" sender:self];
                    });
                });
                
            } else {
              // error
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SystemUIViewControllerModel aLertViewDisplay:@"register error, plase try it again" :@"Notices" :self :@"Got it" :nil];
                    });
                });
            }
              
            
          }];

    });
}

- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
    [self.userIDTextField becomeFirstResponder];
    [self.uniqueIndictor setHidden:YES];
    [self setTitle:@"Step Two"];

    
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  if (isEnableAdvisedSection) {
    return 2;
  } else {
    return 1;
  }
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  if (section == 0) {
    return 1;
  } else {
    return self.advisedUserIDArray.count;
  }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    for (id algoPath in [tableView indexPathsForVisibleRows]) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:algoPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if (algoPath == indexPath) {
            
            if (indexPath.section==1) {
                if (indexPath.row==0) {
                    self.userIDTextField.text = self.advisedUserIDArray[0];
                    
                }
                if (indexPath.row==1) {
                    self.userIDTextField.text = self.advisedUserIDArray[1];
                    
                }
                if (indexPath.row==2) {
                    self.userIDTextField.text = self.advisedUserIDArray[2];
                    
                }
                if (indexPath.row==3) {
                    self.userIDTextField.text = self.advisedUserIDArray[3];
                    
                }
            }
            
            [self submitUserIDValidation:self.userIDTextField.text];

            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    
    
    
    


}


#pragma mark - UItextField delatgate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    self.uniqueIndictor.hidden = YES;
    self.uniqueIndictorImage.hidden = YES;
    return YES;
}

-(void)submitUserIDValidation:(NSString*)uniqueID{
    self.uniqueIndictor.hidden = NO;
    [self.uniqueIndictor startAnimating];
    [WebServicesNsObject
     GET_HTTP_METHOD:
     USERID_CHECK_URL:@{
                        @"perDefindedUserID" : uniqueID
                        }:0 onCompletion:^(NSDictionary *getReuslt) {
                            NSLog(@"%@",getReuslt);
                            [self.uniqueIndictor stopAnimating];
                            self.uniqueIndictor.hidden = YES;
                            self.uniqueIndictorImage.hidden = NO;
                            
                            if ([getReuslt[@"success"] isEqualToString:@"true"]) {
                                self.uniqueIndictorImage.image = [UIImage imageNamed:@"check"];
                                [self.userIDTextField resignFirstResponder];
                                [self.finalRegister setEnabled:YES];
                                isEnableAdvisedSection = NO;
                                
                                
                            }
                            else{
                                self.uniqueIndictorImage.image = [UIImage imageNamed:@"checkErr"];
                                self.advisedUserIDArray =getReuslt[@"message"];
                                [self.userIDTextField resignFirstResponder];
                                [self updateAdvisedUserIDs];
                                isEnableAdvisedSection = YES;
                                [self.tableView reloadData];
                                
                            }
                            
                        }];

}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.returnKeyType ==UIReturnKeyDone) {
        if (textField.text.length > 5 && textField.text.length<15 && [SysNsObject getUserIDRegularExpression:textField.text]) {
            [self submitUserIDValidation:textField.text];
        }
        else{
            [SystemUIViewControllerModel aLertViewDisplay:@"User Id has to start with char, mix of char, digit, _ , and . (dot), The length should  be between 5 and 15." :@"Notices" :self :@"Got it" :nil];
            
        }
        
    }
    

    return YES;
}


-(void)updateAdvisedUserIDs{

    self.advised_uniqueUserID_1.textLabel.text =self.advisedUserIDArray[0];
     self.advised_uniqueUserID_2.textLabel.text =self.advisedUserIDArray[1];
     self.advised_uniqueUserID_3.textLabel.text =self.advisedUserIDArray[2];
     self.advised_uniqueUserID_4.textLabel.text =self.advisedUserIDArray[3];
}






/*
 
 
 
 -(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
 
 if (section==0) {
 return @"Input User ID";
 }
 else {
 return nil;
 }
 
 }
 
 -(NSString*) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
 if (section==0) {
 return @"User id: Start with char, or mixed with digit, _ , or . (dot), The length should  be between 5 and 15.";
 }
 else{
 return  nil;
 }
 
 }
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath
*)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath]
withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the
array, and add a new row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath
*)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath
*)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
