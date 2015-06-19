//
//  PersonalDetailSettingsTableViewController.m
//  TgLnk
//
//  Created by Shepard zhao on 9/06/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "PersonalDetailSettingsTableViewController.h"

@interface PersonalDetailSettingsTableViewController (){
    UIImageView *uiImageView;
}
@property (nonatomic, strong) HeaderView *headerView;

@end

@implementation PersonalDetailSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.navTitle;
    
    self.userInfo = [DatabaseModel queryUserInfo];
    
    //set user avatar
    uiImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 140, 60, 60)];
    [uiImageView setUserInteractionEnabled:YES];
    [uiImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory:)]];
    
    uiImageView = [SystemUIViewControllerModel circleImage:uiImageView :1];
    
    if ([self.userInfo[@"UAVATAR"] isEqualToString:@"None"]) {
        [uiImageView setImage:[UIImage imageNamed:@"Avatar"]];
    }
    else{
        [SystemUIViewControllerModel imageCache:uiImageView :self.userInfo[@"UAVATAR"]:1];
    }

    
    //set user name
    UILabel *username = [[UILabel alloc] initWithFrame:CGRectMake(85, 50, 200, 200)];
    [username setTextColor:[UIColor whiteColor]];
    [username setFont:[UIFont systemFontOfSize:15]];
    [username setText:self.userInfo[@"UNICKNAME"]];
    
    
    
    //set user id
    UILabel *userID = [[UILabel alloc] initWithFrame:CGRectMake(85, 70, 200, 200)];
    [userID setTextColor:[UIColor whiteColor]];
    [userID setFont:[UIFont systemFontOfSize:11]];
    [userID setText:[NSString stringWithFormat:@"UserID: %@",self.userInfo[@"UID"]]];
    
    
    //set user email
    UILabel *useremail = [[UILabel alloc] initWithFrame:CGRectMake(85, 90, 200, 200)];
    [useremail setTextColor:[UIColor whiteColor]];
    [useremail setFont:[UIFont systemFontOfSize:11]];
    [useremail setText:self.userInfo[@"UEMAIL"]];
    
    
    //add to view
    [self.view addSubview:username];
    [self.view addSubview:userID];
    [self.view addSubview:useremail];
    [self.view addSubview:uiImageView];
    
    
    

    self.headerView = [HeaderView instantiateFromNib];
    //set parallax HeaderView
    [self.tableView setParallaxHeaderView:self.headerView
                                     mode:VGParallaxHeaderModeFill
                                   height:200];


    //set the initial
    self.numberOfNoticeBorad.text = [NSString stringWithFormat:@"%@ boards", @"10"];
    self.numberOfPosts.text = [NSString stringWithFormat:@"%@ posts",@"10"];
    
    self.credites.text = [NSString stringWithFormat:@"$ %@",@"10" ];
    
    
    [SystemUIViewControllerModel hideBottomHairline:self.navigationController.navigationBar];

}


/**
 *  select user avatar and progress to upload it
 *
 *  @param gestureRecognizer <#gestureRecognizer description#>
 */
-(void)clickCategory:(UITapGestureRecognizer *)gestureRecognizer
{
   
    JSImagePickerViewController *imagePicker = [[JSImagePickerViewController alloc] init];
    imagePicker.delegate = self;
    [imagePicker showImagePickerInController:self animated:YES];

}



#pragma mark - JSImagePikcerViewControllerDelegate

- (void)imagePickerDidSelectImage:(UIImage *)image {
    
    
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:[SystemUIViewControllerModel fixOrientation:image] cropMode:RSKImageCropModeCircle];
    imageCropVC.delegate = self;
    imageCropVC.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:imageCropVC animated:YES];
}

#pragma mark - RSKImageCropViewController

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image has been cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
{

    //here to resize and compress the uiimage
    
    NSData *tmpData = [SystemUIViewControllerModel compressUIImage:croppedImage quality:0.1 scaledToSize:CGSizeMake(60, 60)];
    
    NSDictionary* nsDictTemp = [[NSDictionary alloc] initWithObjectsAndKeys:self.userInfo[@"UID"],@"UID", nil];
    
    uiImageView.image = [[UIImage alloc] initWithData:tmpData];

    NSLog(@"%@",tmpData);
    //here to upload the user avatar
    
    [WebServicesNsObject uploadImageNormal:tmpData paramters:nsDictTemp baseUrl:USER_AVATAR_URL onCompletion:^(NSDictionary *getReuslt) {
        if ([getReuslt[@"success"] isEqualToString:@"true"] && [getReuslt[@"statusCode"] isEqualToString:@"1"]) {
            // if remote image has been upload successfully
            //put the UIImage into local database
            //update local db
            [DatabaseModel updateUserAvatar:tmpData userID:self.userInfo[@"UID"]];
            
            //add to cache
            [SystemUIViewControllerModel imageCache:uiImageView :getReuslt[@"message"]:1];
            
            
        }
        else if ([getReuslt[@"success"] isEqualToString:@"false"] && [getReuslt[@"statusCode"] isEqualToString:@"0"]){
            // if the remote upload failure
            // alert
            [SystemUIViewControllerModel aLertViewDisplay:getReuslt[@"message"] :@"Notices" :self :@"Cancel":@"Try it again"];

            
        
        }
        else if([getReuslt[@"success"] isEqualToString:@"false"] && [getReuslt[@"statusCode"] isEqualToString:@"3"]){
            // if the network error
            // alert
            [SystemUIViewControllerModel aLertViewDisplay:getReuslt[@"message"] :@"Notices" :self :@"Cancel":@"Try it again"];

        }
        
    }];

    
    [self.navigationController popViewControllerAnimated:YES];
}





- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView shouldPositionParallaxHeader];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.

    if (section == 0) {
        return 3;
    }
    else if(section == 1){
        return 1;
    }
    else {
        return 1;
    }

}


#pragma UITableView 

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 2 && indexPath.row == 0) {
        [self performSegueWithIdentifier:@"accountManageSegue" sender:self];
    }
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
