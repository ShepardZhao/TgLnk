//
//  BoardsTableViewController.m
//  TgLnk
//
//  Created by shepard zhao on 7/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "BoardsTableViewController.h"

@interface BoardsTableViewController (){
    int selectNoticeBoradIndex;
}

@end

@implementation BoardsTableViewController


- (void)loadNewData
{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView.header endRefreshing];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self fetchLatestNoticeBoradsDataSources];
 
        });
        
        
    });
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //loading the content from the db
    self.dataSource = [[DatabaseModel queryBoard] copy];
    [self.tableView reloadData];
}


- (void)viewDidLoad {
  [super viewDidLoad];
    //here to check current network, if wifi, then
    if ([NetworkCheckModel isNetworkConnection]) {
        //get the data from remote server
        [self fetchLatestNoticeBoradsDataSources];
    }
   
    [SystemUIViewControllerModel hideBottomHairline:self.navigationController.navigationBar];
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];//pull down to refresh
    //here we go for initial the database instance
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma customer datasources
/**
 *fetching the latest the noticesboards from web services
 */
-(void) fetchLatestNoticeBoradsDataSources{
    
    self.HUD = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
    self.HUD.delegate = self;
    self.HUD.labelText = @"updating...";
    [WebServicesNsObject
     GET_HTTP_METHOD:
     NOTICESBOARD_URL:nil:0
     onCompletion:^(NSDictionary *getReuslt) {
         
         dispatch_async(dispatch_get_main_queue(), ^(void){
             if ([getReuslt[@"success"] isEqualToString:@"true"]) {
                 
                 //use the restful server API first
                 self.dataSource = getReuslt[@"noticeBoard"];
                
                 //dispatch the data second
                  dispatch_async(dispatch_get_main_queue(), ^{
                  [DatabaseModel createOrUpdateBoardTable:getReuslt[@"noticeBoard"]];
                  });
             }
             else if([getReuslt[@"success"] isEqualToString:@"false"]){
                 self.HUD.labelText = getReuslt[@"message"];
             }
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.HUD hide:YES afterDelay:3];
                 [self.tableView reloadData];

             });


         });
         
        
     }];
    

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return self.dataSource.count;
}

#pragma Table view  delegate
- (UITableViewCell *)tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   BoardsTableViewCell *cell = [tableView
dequeueReusableCellWithIdentifier:@"boardsPostsCellIdentifier"
forIndexPath:indexPath];
    
    
    cell.noticeBoradName.text = self.dataSource[indexPath.row][@"BNAME"];
    cell.noticeBoardNumber.text = [NSString stringWithFormat:@"%@",self.dataSource[indexPath.row][@"BID"]];
    cell.posterNumber.text =  [NSString stringWithFormat:@"Posts: %lu",(unsigned long)[self.dataSource[indexPath.row][@"POSTS"] count] ];
    [SystemUIViewControllerModel imageCache:cell.noticeBoardQRImage :self.dataSource[indexPath.row][@"BIMAGE"]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    
    tapGesture.numberOfTapsRequired=1;
    cell.noticeBoardQRImage.tag =indexPath.row;
    [cell.noticeBoardQRImage setUserInteractionEnabled:YES];
    [cell.noticeBoardQRImage addGestureRecognizer:tapGesture];
    cell.noticeBoardQRImage.userInteractionEnabled = YES;
    
    return cell;
}


- (void)tapDetected:(UIGestureRecognizer *)sender
{
    NSLog(@"%lu", sender.view.tag);   // imageview

    
    // Create an array to store IDMPhoto objects
    NSMutableArray *photos = [NSMutableArray new];
    
    for (int i=0;i<[self.dataSource count];i++) {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",DOMAIN_NAME,self.dataSource[i][@"BIMAGE"]];
        
        IDMPhoto *photo = [IDMPhoto photoWithURL:[NSURL URLWithString:urlStr]];
        photo.caption = self.dataSource[i][@"BNAME"];

        [photos addObject:photo];
    }
    
    // Or use this constructor to receive an NSArray of IDMPhoto objects from your NSURL objects
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
    browser.displayActionButton = YES;
    browser.displayArrowButton = NO;
    browser.displayCounterLabel = YES;

    
    [self presentViewController:browser animated:YES completion:nil];

    
    
    
}
















#pragma Table view delegate select

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectNoticeBoradIndex = (int)indexPath.row;
    
    [self performSegueWithIdentifier:@"showDetailNoticeBoardSegue" sender:self];
}




/*
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
// preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"qrWebViewSegue"]) {
    BoardWebViewViewController *boardCtr =
        (BoardWebViewViewController *)segue.destinationViewController;
   // boardCtr.address = self.qrAddress;
      boardCtr.address = @"http://chaseme.cloudapp.net/1000000000";
  }
    
    if([segue.identifier isEqualToString:@"showDetailNoticeBoardSegue"]){
    
        BoardDetailTableViewController *bDContr = (BoardDetailTableViewController*) segue.destinationViewController;
        
        bDContr.noticeBoradsAndPostsDictionary = self.dataSource[selectNoticeBoradIndex];
        
    
    
    }
    
    
}

#pragma login button action
- (IBAction)loginAction:(id)sender {
}

#pragma qr button action
- (IBAction)qrScanAction:(id)sender {
    
    [self performSegueWithIdentifier:@"qrWebViewSegue" sender:self];

    /*
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
     
     */
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader
    didScanResult:(NSString *)result {

    
  [self dismissViewControllerAnimated:
            YES completion:^{
    
    self.qrAddress = result;

    if (![SysNsObject getHTTPValidationByNSRegularExpression:result]) {
        [SystemUIViewControllerModel aLertViewDisplay:result :@"Notices" :self :@"Cancel":@"Copy"];

    } else {
        [SystemUIViewControllerModel aLertViewDisplay:result :@"Notices" :self :@"Cancel" :@"Go"];
    }

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
