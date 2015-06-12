//
//  BoardDetailTableViewController.h
//  TgLnk
//
//  Created by shepard zhao on 26/05/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardDetailTableViewCell.h"
#import "SystemUIViewControllerModel.h"
#import "LoginViewController.h"
#import "BoardPostTableViewController.h"
#import "IDMPhotoBrowser.h"
#import "DatabaseModel.h"

@interface BoardDetailTableViewController : UITableViewController<LoginViewControllerDelegate,IDMPhotoBrowserDelegate>

@property (strong,nonatomic) NSDictionary *noticeBoradsAndPostsDictionary;
@property (weak, nonatomic) IBOutlet UILabel *boardTitle;
@property (weak, nonatomic) IBOutlet UILabel *boardOwner;
@property (weak, nonatomic) IBOutlet UILabel *boardCode;
@property (weak, nonatomic) IBOutlet UIImageView *boardImage;
@property (weak, nonatomic) IBOutlet UIButton *boardFollow;


@end
