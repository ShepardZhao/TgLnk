//
//  ContactTableViewController.m
//  TgLnk
//
//  Created by shepard zhao on 9/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "ContactTableViewController.h"

@interface ContactTableViewController ()

@end

@implementation ContactTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SystemUIViewControllerModel hideBottomHairline:self.navigationController.navigationBar];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"qrWebViewSegue"]) {
        BoardWebViewViewController *boardCtr =
        (BoardWebViewViewController *)segue.destinationViewController;
        boardCtr.address = self.qrAddress;
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
