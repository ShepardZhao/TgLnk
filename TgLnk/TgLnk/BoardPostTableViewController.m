//
//  BoardPostTableViewController.m
//  TgLnk
//
//  Created by shepard zhao on 26/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "BoardPostTableViewController.h"

@interface BoardPostTableViewController (){
    BOOL uploadStaus;
}

@end

@implementation BoardPostTableViewController

@synthesize delegate;

- (IBAction)postSubmitBtn:(id)sender {
   
    if([self.postTitle.text isEqualToString:@""]){
        [SystemUIViewControllerModel aLertViewDisplay:@"The title of post cannot be empty":@"Notices":self:@"OK":nil];
        
    }
    
    else if ([self.posterEmail.text isEqualToString:@""] || ![SysNsObject getEmailCheckRegularExpression:self.posterEmail.text]) {
        [SystemUIViewControllerModel aLertViewDisplay:@"The email cannot be empty or it is wrong format":@"Notices":self:@"OK":nil];
    }
    
    else if([self.posterPhone.text isEqualToString:@""]){
        [SystemUIViewControllerModel aLertViewDisplay:@"The phone number cannot be empty":@"Notices":self:@"OK":nil];
    }
    else{
        //execute post
        [self executePostAction];
    }
    
    
}


-(void)executePostAction{
    
    [self.view endEditing:YES];
    uploadStaus =YES;
    NSMutableArray *selectImages = [[NSMutableArray alloc] init];
    
    NSData *imageData = UIImageJPEGRepresentation(self.postImage.image, 1);
    
    [selectImages addObject:imageData];
 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        [WebServicesNsObject uploadImageByProgressBar:self.parentViewController :selectImages :@{@"userID":[DatabaseModel queryUserInfo][@"UID"],@"boardID":self.boardID,@"postDesc":self.postTitle.text,@"postEmail":self.posterEmail.text,@"postPhone":self.posterPhone.text,@"mode":@"mobile"} :NOTICESBOARD_POST onCompletion:^(NSDictionary *dictionary) {
            if ([dictionary[@"success"] isEqualToString:@"true"]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [delegate completePost:dictionary[@"message"]];
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                });
                
            }
            
        }];
    
    });
}



#pragma mark - JSImagePikcerViewControllerDelegate



- (void)imagePickerDidSelectImage:(UIImage *)image {
    
        RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:[SystemUIViewControllerModel fixOrientation:image] cropMode:RSKImageCropModeSquare];
    imageCropVC.delegate = self;
    imageCropVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:imageCropVC animated:YES];
    [self.navigationController hidesBottomBarWhenPushed];

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
    NSData *tmpData = [SystemUIViewControllerModel compressUIImage:croppedImage quality:0.5 scaledToSize:CGSizeMake(POST_IMAGE_WIDTH, POST_IMAGE_HEIGHT)];
    self.postImage.image = [[UIImage alloc] initWithData:tmpData];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)closePost:(id)sender {
    
    if (uploadStaus) {
          [SystemUIViewControllerModel aLertViewDisplay:@"Please waiting for uploading progress finished":@"Notices":self:@"OK":nil];
    }
    else{
      
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];

    }
  
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.postTitle becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userInfo = [[NSDictionary alloc] initWithDictionary:[DatabaseModel queryUserInfo]];
    
    
    [SystemUIViewControllerModel hideBottomHairline:self.navigationController.navigationBar];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImage)];
    tapGesture.numberOfTapsRequired=1;
    [self.postImage addGestureRecognizer:tapGesture];
    
    [self.postTitle setPlaceholder:@"i.e The free discount of shopping card"];
    
    [self.posterEmail setPlaceholder:self.userInfo[@"UEMAIL"]];
    
    [self.posterPhone setPlaceholder:self.userInfo[@"UPHONE"]];
    
    
    self.title = @"Post";
 
}
    

-(void)selectImage{
    [[self view] endEditing:YES];
    JSImagePickerViewController *imagePicker = [[JSImagePickerViewController alloc] init];
    imagePicker.delegate = self;
    [imagePicker showImagePickerInController:self animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
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
