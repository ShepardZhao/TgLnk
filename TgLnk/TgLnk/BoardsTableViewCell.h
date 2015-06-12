//
//  BoardsTableViewCell.h
//  TgLnk
//
//  Created by shepard zhao on 9/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseModel.h"
#import "SystemUIViewControllerModel.h"
@interface BoardsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *noticeBoradName;
@property (weak, nonatomic) IBOutlet UILabel *noticeBoardNumber;

@property (weak, nonatomic) IBOutlet UILabel *posterNumber;
@property (weak, nonatomic) IBOutlet UIButton *followOrUnFollowBtn;
@property (weak, nonatomic) IBOutlet UIImageView *noticeBoardQRImage;

@property DatabaseModel *db;

@end
