//
//  ContactTableViewController.m
//  TgLnk
//
//  Created by shepard zhao on 9/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "ContactTableViewController.h"

@interface ContactTableViewController (){
    NSMutableArray *contactList;
}

@end

@implementation ContactTableViewController


#pragma mark delegate method from LoginViewController
-(void)loginDismissed{
    [self refreshTableView];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


-(void)refreshTableView{
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(netWorkDisplayContact)];//pull down to refresh
    [self.tableView setContentOffset:CGPointMake(0, -70) animated:YES];
    [self.tableView.header beginRefreshing];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [SystemUIViewControllerModel hideBottomHairline:self.navigationController.navigationBar];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if ([DatabaseModel queryUserLoginStatus]) {
        [self refreshTableView];
        }else{
        [self performSegueWithIdentifier:@"contactLoginSegue" sender:self];
    }
}


- (IBAction)searchBtn:(id)sender {
    // if login
    if ([DatabaseModel queryUserLoginStatus]) {
        [self performSegueWithIdentifier:@"searchContactSegue" sender:self];
    
    }
    // if not login
    else{
        [self performSegueWithIdentifier:@"contactLoginSegue" sender:self];
    
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)alertLogin{
    [self performSegueWithIdentifier:@"contactLoginSegue" sender:self];
}


-(void)netWorkDisplayContact{
    if (![DatabaseModel queryUserLoginStatus]) {
        contactList = [[NSMutableArray alloc] init];
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];

        [SystemUIViewControllerModel setAlertBanner:self message:@"Attention!, you're not login yet. Click to login" selector:@selector(alertLogin)];
    }
    else{
        
    [WebServicesNsObject
     GET_HTTP_METHOD:
     CONTACT_SEARCH:@{@"sUser":[DatabaseModel queryUserInfo][@"UID"],@"stype":@"getAll"}:0
     onCompletion:^(NSDictionary *getReuslt) {
         if ([getReuslt[@"success"] isEqualToString:@"true"] && [getReuslt[@"statusCode"] isEqualToString:@"1"]) {
             contactList = getReuslt[@"message"];
             [self.tableView reloadData];
             [self.tableView.header endRefreshing];
             
             [SystemUIViewControllerModel setAlertBanner:self message:@"" selector:@selector(alertLogin)];

             
         }
         else if ([getReuslt[@"success"] isEqualToString:@"false"] && [getReuslt[@"statusCode"] isEqualToString:@"0"]){
             [SystemUIViewControllerModel setAlertBanner:self message:getReuslt[@"message"] selector:@selector(alertLogin)];

         }
         else if ([getReuslt[@"success"] isEqualToString:@"false"] && [getReuslt[@"statusCode"] isEqualToString:@"3"]){
             [SystemUIViewControllerModel setAlertBanner:self message:getReuslt[@"message"] selector:@selector(alertLogin)];         }
         
    }];
}

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [contactList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCellIdentifier" forIndexPath:indexPath];
    [SystemUIViewControllerModel imageCache:cell.contactImage:contactList[indexPath.row][@"UAVATAR"]:1];
    cell.contactUsername.text = contactList[indexPath.row][@"UNICKNAME"];
    cell.contactUserID.text = [NSString stringWithFormat:@"User ID: %@",contactList[indexPath.row][@"UID"]];
    return cell;
}


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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"contactLoginSegue"]) {
        LoginViewController *logCtl = (LoginViewController *)segue.destinationViewController;
        logCtl.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"searchContactSegue"]){
        
    }
    
}


#pragma qr button action
- (IBAction)qrScanAction:(id)sender {
    if ([QRCodeReader
         supportsMetadataObjectTypes:@[ AVMetadataObjectTypeQRCode ]]) {
        static QRCodeReaderViewController *reader = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            reader = [QRCodeReaderViewController new];
            reader.modalPresentationStyle = UIModalPresentationFormSheet;
        });
        reader.delegate = self;
        
        [self presentViewController:reader animated:YES completion:NULL];
    } else {
        [SystemUIViewControllerModel aLertViewDisplay:@"Reader not supported by the current device" :@"Error" :self :@"OK" :nil];
        
    }
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader
 didScanResult:(NSString *)result {
    [self dismissViewControllerAnimated:
     YES completion:^{
         self.HUD = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
         self.HUD.delegate = self;
         self.HUD.labelText = @"Scan Completed";
         [self.HUD hide:YES afterDelay:2];
         
         self.qrAddress = result;
         
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             if (![SysNsObject getHTTPValidationByNSRegularExpression:result]) {
                 [SystemUIViewControllerModel aLertViewDisplay:result :@"Notices" :self :@"Cancel":@"Copy"];
                 
             } else {
                 [SystemUIViewControllerModel aLertViewDisplay:result :@"Notices" :self :@"Cancel" :@"Go"];
             }
             
         });
         
         
     }];

}



#pragma UIAlertViewDelegate method
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Go"]) {
        [self performSegueWithIdentifier:@"qrWebViewSegue" sender:self];
    }
    else if([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Copy"]){
        
        [UIPasteboard generalPasteboard].string = self.qrAddress;
        
        [SystemUIViewControllerModel aLertViewDisplay:@"Copyed" :@"Notices" :self :@"OK" :@"nil"];
    }
    
}


- (void)readerDidCancel:(QRCodeReaderViewController *)reader {
    [self dismissViewControllerAnimated:YES completion:NULL];
}





@end
