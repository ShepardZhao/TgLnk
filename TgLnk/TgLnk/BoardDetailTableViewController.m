//
//  BoardDetailTableViewController.m
//  TgLnk
//
//  Created by shepard zhao on 26/05/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "BoardDetailTableViewController.h"

@interface BoardDetailTableViewController ()

@end

@implementation BoardDetailTableViewController


-(void)completePost:(NSString *)postTitle postUIImage:(UIImage *)postUIImage postEmail:(NSString *)postEmail postPhone:(NSString *)postPhone{
    
   // NSDictionary *addDict= [NSDictionary alloc] initWithObjectsAndKeys:@"PIMG",postUIImage,@"PNAME",postTitle,@""

}


-(void)loginDismissed{

    [self performSegueWithIdentifier:@"boardPostSegue" sender:self];

}

- (void)viewWillAppear:(BOOL)animated {
    
  [super viewWillAppear:animated];

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


- (void)viewDidLoad {
  [super viewDidLoad];
  
    //set the title for this view
  self.title = @"Notes";
    
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

    
    //set the board following button
     self.boardFollow = [SystemUIViewControllerModel styleButton:self.boardFollow cornerRadius:6.0f borderWidth:1.0f borderColor:[RGB2UICOLOR(245, 245, 245,1) CGColor]];
    
    
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
  return [self.postsArray count];
}

- (IBAction)followingAction:(id)sender {
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  BoardDetailTableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"BoardDetailLayerCell"
                                      forIndexPath:indexPath];

  [SystemUIViewControllerModel
      imageCache:cell.
       postImage:self.postsArray[indexPath.row][@"PIMG"]:0];

  cell.postTitle.text =
      self.postsArray[indexPath.row][@"PNAME"];
  cell.postDate.text =
      self.postsArray[indexPath.row][@"PDATE"];
  cell.postTime.text =
      self.postsArray[indexPath.row][@"PTIME"];
    //set the poster image
    [SystemUIViewControllerModel
     imageCache:[SystemUIViewControllerModel circleImage:cell.posterImage :0]:self.postsArray[indexPath.row][@"UAVATAR"]:1];
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
    
  for (int i = 0; i < [self.postsArray count];
       i++) {
    NSString *urlStr =
        [NSString stringWithFormat:@"%@%@", DOMAIN_NAME,
                                   self.postsArray[i][@"PIMG"]];
    IDMPhoto *photo = [IDMPhoto photoWithURL:[NSURL URLWithString:urlStr]];
    photo.caption = self.postsArray[i][@"PNAME"];

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"boardPostSegue"]) {
    BoardPostTableViewController *bPCtr =
        (BoardPostTableViewController *)segue.destinationViewController;
    bPCtr.boardID = self.boardCodeValue;
  }
    
    
}

@end
