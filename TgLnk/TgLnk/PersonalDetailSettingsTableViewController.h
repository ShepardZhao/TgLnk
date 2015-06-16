//
//  PersonalDetailSettingsTableViewController.h
//  TgLnk
//
//  Created by Shepard zhao on 9/06/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+VGParallaxHeader.h"
#import "HeaderView.h"
#import "JSImagePickerViewController.h"
#import "RSKImageCropViewController.h"
#import "DatabaseModel.h"
#import "WebServicesNsObject.h"
#import "SystemUIViewControllerModel.h"
@interface PersonalDetailSettingsTableViewController : UITableViewController<JSImagePickerViewControllerDelegate,RSKImageCropViewControllerDelegate>
@property (retain,nonatomic) NSDictionary *userInfo;

@property (weak, nonatomic) IBOutlet UILabel *numberOfNoticeBorad;

@property (weak, nonatomic) IBOutlet UILabel *numberOfPosts;

@property (weak, nonatomic) IBOutlet UILabel *credites;

@property (strong,nonatomic) NSString *navTitle;
@end
