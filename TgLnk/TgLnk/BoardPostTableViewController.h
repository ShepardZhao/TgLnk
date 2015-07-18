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

@protocol BoardPostTableViewControllerDelegate <NSObject>

-(void)completePost:(NSDictionary *)dictionary;

@end
@interface BoardPostTableViewController : UITableViewController<JSImagePickerViewControllerDelegate,RSKImageCropViewControllerDelegate>{
    __unsafe_unretained id<BoardPostTableViewControllerDelegate> delegate;
}
@property (assign,nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UITextField *postTitle;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UITextField *posterEmail;
@property (weak, nonatomic) IBOutlet UITextField *posterPhone;
@property (strong,nonatomic) NSString *boardID;
@property (strong, nonatomic)  NSDictionary *userInfo;



@end
