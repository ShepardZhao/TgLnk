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
    NSDictionary *boardArray;
}

@end

@implementation BoardsTableViewController
- (IBAction)segmentBtn:(id)sender {
    //check segment
    if (self.segemented.selectedSegmentIndex == 1){
        [self performSegueWithIdentifier:@"explorerSegue" sender:self];
    }
    else if (self.segemented.selectedSegmentIndex == 2){
        [self performSegueWithIdentifier:@"followSegue" sender:self];
    }
}


- (void)loadNewData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self fetchLatestNoticeBoradsDataSources];
    });
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //initial the tablview
    
    if ([NetworkCheckModel isNetworkConnection]) {
        [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];//pull down to refresh
        [self.tableView setContentOffset:CGPointMake(0, -70) animated:YES];
        [self.tableView.header beginRefreshing];
    }
    else{
        self.dataSource = [[DatabaseModel queryBoard] copy];
        [self.tableView reloadData];
    }


}

- (void)viewDidLoad {
  [super viewDidLoad];
  [SystemUIViewControllerModel hideBottomHairline:self.navigationController.navigationBar];
  self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    if (![DatabaseModel queryUserLoginStatus]) {
        [SystemUIViewControllerModel setAlertBanner:self message:@"Attention!, you're not login yet. Click to login" selector:@selector(alertLogin)];
    }
    
}


-(void)alertLogin{
    [self performSegueWithIdentifier:@"boardLoginCheckSegue" sender:self];
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
    
    NSString *uid;
    if ([DatabaseModel queryUserLoginStatus]) {
        uid = [[NSString alloc] initWithString:[DatabaseModel queryUserInfo][@"UID"]];
    }
    else{
        uid =@"null";
    }
    
    [WebServicesNsObject
     GET_HTTP_METHOD:
     NOTICESBOARD_URL:@{@"requestType":@"json",@"userid":uid}:0
     onCompletion:^(NSDictionary *getReuslt) {

         dispatch_async(dispatch_get_main_queue(), ^(void){
             if ([getReuslt[@"success"] isEqualToString:@"true"] && [getReuslt[@"statusCode"] isEqualToString:@"1"]) {
                 
                 //use the restful server API first
                 self.dataSource = getReuslt[@"message"];
                 
            
                 //dispatch the data second
                  dispatch_async(dispatch_get_main_queue(), ^{
                  [DatabaseModel createOrUpdateBoardTable:getReuslt[@"message"]];
                  [self.tableView reloadData];
                  [self.tableView.header endRefreshing];

                  });
             }
             else if([getReuslt[@"success"] isEqualToString:@"false"] && [getReuslt[@"statusCode"]isEqualToString:@"0"]){
                 //self.HUD.labelText = getReuslt[@"message"];
                 [SystemUIViewControllerModel setAlertBanner:self message:getReuslt[@"message"] selector:nil];
             }
             
             else if([getReuslt[@"success"] isEqualToString:@"false"] && [getReuslt[@"statusCode"] isEqualToString:@"3"]){
                 //self.HUD.labelText = getReuslt[@"message"];
                 [SystemUIViewControllerModel setAlertBanner:self message:getReuslt[@"message"] selector:nil];
             
             }

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
    
    //notice board name
    cell.noticeBoradName.text = self.dataSource[indexPath.row][@"BNAME"];
    
    //notice board id
    cell.noticeBoardNumber.text = [NSString stringWithFormat:@"%@",self.dataSource[indexPath.row][@"BID"]];
   
    //the number of posts for this noticeboard
    cell.posterNumber.text =  [NSString stringWithFormat:@"Posts: %lu",(unsigned long)[self.dataSource[indexPath.row][@"POSTS"] count] ];
    //cell image
    [SystemUIViewControllerModel imageCache:cell.noticeBoardQRImage :self.dataSource[indexPath.row][@"BIMAGE"]:0];
    
    //add UITapGestureRecognizer on this notice board
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
    tapGesture.numberOfTapsRequired=1;
    cell.noticeBoardQRImage.tag =indexPath.row;
    [cell.noticeBoardQRImage setUserInteractionEnabled:YES];
    [cell.noticeBoardQRImage addGestureRecognizer:tapGesture];
    cell.noticeBoardQRImage.userInteractionEnabled = YES;
    
    //pass the noticeboard with current indexPath.row to the table cell
    cell.cellContent = self.dataSource[indexPath.row];
    
    
    return cell;
}





- (void)tapDetected:(UIGestureRecognizer *)sender{
    // Create an array to store IDMPhoto objects
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    
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



-(void)getClickedStatus:(BOOL)status{
    
    if (status) {
        self.segemented.selectedSegmentIndex = 0;
    }


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

    if ([segue.identifier isEqualToString:@"explorerSegue"]) {
        ExplorerBoardViewController *exCtr = (ExplorerBoardViewController*) segue.destinationViewController;
        exCtr.mapViewDelegate = self;
    }
    
    if([segue.identifier isEqualToString:@"showDetailNoticeBoardSegue"]){
        BoardDetailTableViewController *bDContr = (BoardDetailTableViewController*) segue.destinationViewController;
        bDContr.boardTitleValue = self.dataSource[selectNoticeBoradIndex][@"BNAME"];
        bDContr.boardCodeValue = self.dataSource[selectNoticeBoradIndex][@"BID"];
        bDContr.boardImageValue = self.dataSource[selectNoticeBoradIndex][@"BIMAGE"];
        bDContr.boardOwnerValue = self.dataSource[selectNoticeBoradIndex][@"UNICKNAME"];
        bDContr.boardFollow = self.dataSource[selectNoticeBoradIndex][@"FOLLOW_STATUS"];
        bDContr.ownerImageValue = self.dataSource[selectNoticeBoradIndex][@"UAVATAR"];
        bDContr.postsArray = self.dataSource[selectNoticeBoradIndex][@"POSTS"];
    }
    
    if ([segue.identifier isEqualToString:@"activeBoardSegue"]) {
        BoardActiveViewController *bAContr = (BoardActiveViewController *) segue.destinationViewController;
        bAContr.boardArray = boardArray;
        
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
             [self.HUD hide:YES afterDelay:1];
    
             self.qrAddress = result;
             
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 
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
        
        [WebServicesNsObject
         GET_HTTP_METHOD:
         NOTICESBOARD_STATUS_QUERY:@{@"queryID":[QRAnalysisNSObject QRUrlAnalysis:self.qrAddress]}:0
         onCompletion:^(NSDictionary *getReuslt) {
             if ([getReuslt[@"success"] isEqualToString:@"true"] && [getReuslt[@"statusCode"] isEqualToString:@"1"]) {
                 if ([getReuslt[@"message"][@"BVIEW_STATUS"] isEqualToNumber:[NSNumber numberWithInt:0]]) {
                     //jump to active page
                     boardArray = getReuslt[@"message"];
                     [self performSegueWithIdentifier:@"activeBoardSegue" sender:self];
                 }
                 else if ([getReuslt[@"message"][@"BVIEW_STATUS"] isEqualToNumber:[NSNumber numberWithInt:1]]){
                     //jump to detail page
                     boardArray = getReuslt[@"message"];
                     [self performSegueWithIdentifier:@"showDetailNoticeBoardSegue" sender:self];
                 
                 }
                 
             
             }
             else if ([getReuslt[@"success"] isEqualToString:@"false"] && [getReuslt[@"statusCode"] isEqualToString:@"0"]){
                 [SystemUIViewControllerModel aLertViewDisplay:getReuslt[@"message"] :@"Notices" :self :nil :@"Ok"];
             }
             else if ([getReuslt[@"success"] isEqualToString:@"false"] && [getReuslt[@"statusCode"] isEqualToString:@"3"]){
                 [SystemUIViewControllerModel aLertViewDisplay:getReuslt[@"message"] :@"Notices" :self :nil:@"Ok"];
             }
         }];
    
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
