//
//  BoardDetailTableViewController.m
//  TgLnk
//
//  Created by shepard zhao on 26/05/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "BoardDetailTableViewController.h"

@interface BoardDetailTableViewController (){
    NSMutableArray *postsArray;
}
@property (nonatomic, assign) BOOL cellHeightCacheEnabled;

@end

@implementation BoardDetailTableViewController


-(void)completePost:(NSDictionary *)dictionary{
    
    
    //initial a NSDictionary
    NSDictionary *addDict= [[NSDictionary alloc] initWithObjectsAndKeys:dictionary[@"BID"],@"BID",dictionary[@"PDATE"],@"PDATE",dictionary[@"PEMAIL"],@"PEMAIL",dictionary[@"PID"],@"PID",dictionary[@"PIMG"],@"PIMG",dictionary[@"PNAME"],@"PNAME",dictionary[@"PPHONE"],@"PPHONE",dictionary[@"PTIME"],@"PTIME",[DatabaseModel queryUserInfo][@"UID"],@"UID",nil];
    
    
    NSMutableArray *newMulArray = [[NSMutableArray alloc] initWithObjects:addDict,nil];

    for (NSArray *item in postsArray) {
        [newMulArray addObject:item];
    }
    
    
    postsArray = [[NSMutableArray alloc] initWithArray:newMulArray];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //insert the new record to the table
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}



#pragma mark getPosts according to board ID
-(void)getPosts{
    [WebServicesNsObject GET_HTTP_METHOD:NOTICESBOARD_POST :@{@"type":self.requestType,@"requestID":self.requestID} :0 onCompletion:^(NSDictionary * dictionary) {
        if ([dictionary[@"success"] isEqualToString:@"true"] && [dictionary[@"statusCode"] isEqualToString:@"1"]) {
            postsArray = dictionary[@"message"];

        }
        else if([dictionary[@"success"] isEqualToString:@"false"] && [dictionary[@"statusCode"] isEqualToString:@"0"]){
            [SystemUIViewControllerModel setAlertBanner:self message:dictionary[@"message"] selector:nil];
        }
        else if ([dictionary[@"success"] isEqualToString:@"false"] && [dictionary[@"statusCode"] isEqualToString:@"3"]){

            [SystemUIViewControllerModel setAlertBanner:self message:dictionary[@"message"] selector:nil];
        }
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];

        [self.tableView.header endRefreshing];
        
    }];
}



#pragma mark -- loadGetPost
- (void)loadGetPost{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getPosts];
    });
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}



- (IBAction)composePost:(id)sender {
    if ([DatabaseModel queryUserLoginStatus]) {
        //go to post
        [self performSegueWithIdentifier:@"boardPostSegue" sender:self];
    }
    else{
        //go to login and register
        [self performSegueWithIdentifier:@"loginAndSegue" sender:self];
    }
}

-(void)alertLogin{
    [self performSegueWithIdentifier:@"boardLoginCheckSegue" sender:self];
}

- (IBAction)followingAction:(id)sender {
    
    
    NSDictionary *paramter = [[NSDictionary alloc] initWithObjectsAndKeys:self.boardCodeValue,@"bid", [DatabaseModel queryUserInfo][@"UID"],@"uid", nil];
    if ([self.boardFillowValue isEqualToString:@"true"]) {
        //cancel follow
        
        [WebServicesNsObject DELETE_HTTP_METHOD:NOTICEBOARD_FOLLOW :paramter :0 onCompletion:^(NSDictionary *getReuslt) {
            
            if ([getReuslt[@"success"] isEqualToString:@"true"] && [getReuslt[@"statusCode"] isEqualToString:@"1"]) {
                //here to set successfully status
                [self boardFollwStatus];
                self.boardFillowValue = @"false";
            }
            else if ([getReuslt[@"success"] isEqualToString:@"false"] && [getReuslt[@"statusCode"] isEqualToString:@"0"]) {
                [SystemUIViewControllerModel setAlertBanner:self message:getReuslt[@"message"] selector:@selector(alertLogin)];
            }
            else if ([getReuslt[@"success"] isEqualToString:@"false"] && [getReuslt[@"statusCode"] isEqualToString:@"3"]) {
                [SystemUIViewControllerModel setAlertBanner:self message:getReuslt[@"message"] selector:nil];
            }
            
        }];
        
    }
    else {
        //set up follow
        
        [WebServicesNsObject POST_HTTP_METHOD:NOTICEBOARD_FOLLOW :paramter :0 onCompletion:^(NSDictionary *getReuslt) {
            
            if ([getReuslt[@"success"] isEqualToString:@"true"] && [getReuslt[@"statusCode"] isEqualToString:@"1"]) {
                
                //here to set successfully status
                [self boardFollowingStatus];
                self.boardFillowValue = @"true";


            }
            else if ([getReuslt[@"success"] isEqualToString:@"false"] && [getReuslt[@"statusCode"] isEqualToString:@"0"]) {
                [SystemUIViewControllerModel setAlertBanner:self message:getReuslt[@"message"] selector:@selector(alertLogin)];
                
                
            }
            else if ([getReuslt[@"success"] isEqualToString:@"false"] && [getReuslt[@"statusCode"] isEqualToString:@"3"]) {
                [SystemUIViewControllerModel setAlertBanner:self message:getReuslt[@"message"] selector:nil];
                
            }
        }];

        
        
    }
    
}


-(void) boardFollwStatus{

    [self.boardFollow setTitle:@"Follow" forState:UIControlStateNormal];
    [self.boardFollow setBackgroundColor:RGB2UICOLOR(231, 231, 231,1.0)];
    [self.boardFollow setTitleColor:RGB2UICOLOR(255, 255, 255,1.0) forState:UIControlStateNormal];



}


-(void) boardFollowingStatus{

    [self.boardFollow setTitle:@"Following" forState:UIControlStateNormal];
    [self.boardFollow setBackgroundColor:RGB2UICOLOR(231, 76, 60,1.0)];
    [self.boardFollow setTitleColor:RGB2UICOLOR(255, 255, 255,1.0) forState:UIControlStateNormal];


}




- (void)viewDidLoad {
  [super viewDidLoad];
    

    //set the title for this view
    self.title = @"Notes";
    
    self.boardFollow = [SystemUIViewControllerModel styleButton:self.boardFollow cornerRadius:6.0f borderWidth:1.0f borderColor:[RGB2UICOLOR(245, 245, 245,1) CGColor]];

    //check the following status
    if ([self.boardFillowValue isEqualToString:@"true"]) {
        [self boardFollowingStatus];
    }
    else{
    
        [self boardFollwStatus];
    }
    
    
    //set the board title
    self.boardTitle.text = self.boardTitleValue;
    //set the board's own name
    self.boardOwner.text = self.boardOwnerValue;
    //set the board id
    self.boardCode.text = [NSString
      stringWithFormat:@"%@", self.boardCodeValue];
    //set the board QR image
    [SystemUIViewControllerModel
     imageCache:self.boardImage:self.boardImageValue:0];
    
    //set the owner image
    [SystemUIViewControllerModel
     imageCache:[SystemUIViewControllerModel circleImage:self.ownerImage :0]:self.ownerImageValue:0];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    //set the tap and enable on the boardImage
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapBoardImageDetected)];
    tapGesture.numberOfTapsRequired = 1;
    [self.boardImage setUserInteractionEnabled:YES];
    [self.boardImage addGestureRecognizer:tapGesture];


    postsArray = [[NSMutableArray alloc] init];
    
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadGetPost)];//pull down to refresh
    
    [self.tableView.header beginRefreshing];
    
    
    
    
    
}


-(void)tapBoardImageDetected{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    
    
    IDMPhoto *photo = [IDMPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DOMAIN_NAME,[NSURL URLWithString:self.boardImageValue]]]];

    photo.caption = self.boardTitleValue;
    
    [photos addObject:photo];
    
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];

    browser.displayActionButton = YES;
    browser.displayArrowButton = NO;
    browser.displayCounterLabel = YES;
    
    [self presentViewController:browser animated:YES completion:nil];

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

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [postsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  BoardDetailTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"BoardDetailLayerCell"
                                      forIndexPath:indexPath];

  [SystemUIViewControllerModel
      imageCache:cell.
       postImage:postsArray[indexPath.row][@"PIMG"]:0];

  cell.postTitle.text = postsArray[indexPath.row][@"PNAME"];
  cell.postDate.text =  postsArray[indexPath.row][@"PDATE"];
  cell.postTime.text =  postsArray[indexPath.row][@"PTIME"];
    //set the poster image
    [SystemUIViewControllerModel
     imageCache:[SystemUIViewControllerModel circleImage:cell.posterImage :0]:  postsArray[indexPath.row][@"UAVATAR"]:1];
  UITapGestureRecognizer *tapGesture =
      [[UITapGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(tapDetected:)];

  tapGesture.numberOfTapsRequired = 2;
  cell.postImage.tag = indexPath.row;
  [cell.postImage setUserInteractionEnabled:YES];
  [cell.postImage addGestureRecognizer:tapGesture];
  cell.postImage.userInteractionEnabled = YES;
  return cell;
}


- (void)tapDetected:(UIGestureRecognizer *)sender {

  // Create an array to store IDMPhoto objects
  NSMutableArray *photos = [[NSMutableArray alloc] init];
    
  for (int i = 0; i < [postsArray count];
       i++) {
    NSString *urlStr =
        [NSString stringWithFormat:@"%@%@", DOMAIN_NAME, postsArray[i][@"PIMG"]];
    IDMPhoto *photo = [IDMPhoto photoWithURL:[NSURL URLWithString:urlStr]];
    photo.caption = postsArray[i][@"PNAME"];

    [photos addObject:photo];
  }

  // Or use this constructor to receive an NSArray of IDMPhoto objects from your
  // NSURL objects

  IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:photos];
  browser.displayActionButton = YES;
  browser.displayArrowButton = NO;
  browser.displayCounterLabel = YES;

  [self presentViewController:browser animated:YES completion:nil];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath
*)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"boardPostSegue"]) {
    BoardPostTableViewController *bPCtr =
        (BoardPostTableViewController *)segue.destinationViewController;
    bPCtr.boardID = self.boardCodeValue;
    bPCtr.delegate = self;
  }

}

@end
