//
//  BoardsTableViewCell.m
//  TgLnk
//
//  Created by shepard zhao on 9/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "BoardsTableViewCell.h"

@implementation BoardsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    [self.noticeBoardQRImage setImage:[UIImage imageNamed:@"NoticeBoard_placeholder"]];
    
    self.followOrUnFollowBtn = [SystemUIViewControllerModel styleButton:self.followOrUnFollowBtn cornerRadius:6.0f borderWidth:1.0f borderColor:[RGB2UICOLOR(245, 245, 245,1) CGColor]];

  
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
