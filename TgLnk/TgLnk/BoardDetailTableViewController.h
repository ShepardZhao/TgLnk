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
#import "BoardPostTableViewController.h"
#import "IDMPhotoBrowser.h"
#import "DatabaseModel.h"
#import "BoardPostTableViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MJRefresh.h"



@interface BoardDetailTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,IDMPhotoBrowserDelegate,BoardPostTableViewControllerDelegate>
//here is the request items, that will request the requestType and requestID
@property (strong,nonatomic) NSString *requestType;
@property (strong,nonatomic) NSString *requestID;


//here is the board basic information
@property (strong,nonatomic) NSString *boardTitleValue;
@property (strong,nonatomic) NSString *boardOwnerValue;
@property (strong,nonatomic) NSString *boardCodeValue;
@property (strong,nonatomic) NSString *boardImageValue;
@property (strong,nonatomic) NSString *ownerImageValue;
@property (strong,nonatomic) NSString *boardFillowValue;



@property (weak, nonatomic) IBOutlet UILabel *boardTitle;
@property (weak, nonatomic) IBOutlet UILabel *boardOwner;
@property (weak, nonatomic) IBOutlet UILabel *boardCode;
@property (weak, nonatomic) IBOutlet UIImageView *boardImage;
@property (weak, nonatomic) IBOutlet UIButton *boardFollow;
@property (weak, nonatomic) IBOutlet UIImageView *ownerImage;

@end
