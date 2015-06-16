//
//  BoardPostTableViewController.h
//  TgLnk
//
//  Created by shepard zhao on 26/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SystemUIViewControllerModel.h"
#import "JSImagePickerViewController.h"
#import "RSKImageCropViewController.h"
#import "WebServicesNsObject.h"
#import "SysNsObject.h"
#import "DatabaseModel.h"

@protocol BoardPostTableViewController <NSObject>

-(void)completePost:(NSString *)postTitle postUIImage:(UIImage *)postUIImage postEmail:(NSString *)postEmail postPhone:(NSString *)postPhone;

@end
@interface BoardPostTableViewController : UITableViewController<JSImagePickerViewControllerDelegate,RSKImageCropViewControllerDelegate,RSKImageCropViewControllerDataSource>{
    __unsafe_unretained id<BoardPostTableViewController> delegate;
}
@property (assign,nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UITextField *postTitle;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UITextField *posterEmail;
@property (weak, nonatomic) IBOutlet UITextField *posterPhone;
@property (strong,nonatomic) NSString *boardID;
@property (weak, nonatomic)  NSDictionary *userInfo;



@end
