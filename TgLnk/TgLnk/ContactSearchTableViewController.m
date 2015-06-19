//
//  ContactSearchTableViewController.m
//  TgLnk
//
//  Created by Zhao, Shepard(AWF) on 6/17/15.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "ContactSearchTableViewController.h"

@interface ContactSearchTableViewController (){
    NSString *currentUserID;
}

@end

@implementation ContactSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    currentUserID = [DatabaseModel queryUserInfo][@"UID"];
   self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    
    
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.contactSearchBar becomeFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self searchAction:searchBar.text];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.searchResultDict count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    [SystemUIViewControllerModel imageCache:cell.contactImage:self.searchResultDict[indexPath.row][@"UAVATAR"]:1];
    cell.contactUsername.text = self.searchResultDict[indexPath.row][@"UNICKNAME"];
    cell.contactUserID.text = [NSString stringWithFormat:@"User ID: %@",self.searchResultDict[indexPath.row][@"UID"]];
    cell.cellDictionary = self.searchResultDict[indexPath.row];
    return cell;
}


/**
 *  search action
 *
 *  @param searchContent pass the searchContent through
 */
- (void)searchAction:(NSString *)searchContent{
  
    self.HUD = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
    self.HUD.labelText = @"Searching...";
    
    [WebServicesNsObject
     GET_HTTP_METHOD:
     CONTACT_SEARCH:@{@"sUser":searchContent,@"stype":@"specific"}:0
     onCompletion:^(NSDictionary *getReuslt) {
         
         if ([getReuslt[@"success"] isEqualToString:@"true"] && [getReuslt[@"statusCode"] isEqualToString:@"1"]) {
             self.HUD.labelText = @"Search Done";
             self.searchResultDict = getReuslt[@"message"];
         }
         else if ([getReuslt[@"success"] isEqualToString:@"false"] && [getReuslt[@"statusCode"] isEqualToString:@"0"]){
             self.HUD.labelText = getReuslt[@"message"];
             self.searchResultDict = nil;
         }
         else if ([getReuslt[@"success"] isEqualToString:@"false"] && [getReuslt[@"statusCode"] isEqualToString:@"3"]){
         
             self.HUD.labelText = getReuslt[@"message"];
             self.searchResultDict = nil;

         }
         
         dispatch_async(dispatch_get_main_queue(), ^(void){
             [self.HUD hide:YES afterDelay:1];
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self.tableView reloadData];
             });
         });
     
     
     }];


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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
