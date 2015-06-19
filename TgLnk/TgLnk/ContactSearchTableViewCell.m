//
//  ContactSearchTableViewCell.m
//  TgLnk
//
//  Created by Zhao, Shepard(AWF) on 6/17/15.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "ContactSearchTableViewCell.h"
@implementation ContactSearchTableViewCell

- (void)awakeFromNib {

    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
    self.contactAddBtn = [SystemUIViewControllerModel styleButton:self.contactAddBtn cornerRadius:6.0f borderWidth:0.0f borderColor:[RGB2UICOLOR(245, 245, 245,1) CGColor]];

    self.contactImage = [SystemUIViewControllerModel circleImage:self.contactImage :1];

}

- (IBAction)addUserBtn:(id)sender {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    self.HUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
    self.HUD.labelText = @"Adding...";
    
    if ([[DatabaseModel queryUserInfo][@"UID"] isEqualToString:self.cellDictionary[@"UID"]]) {
        [SystemUIViewControllerModel aLertViewDisplay:@"You cannot add yourself into contact list":@"Notices":self:@"OK":nil];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.HUD hide:YES];
        });
    }else {
        
        [WebServicesNsObject
         POST_HTTP_METHOD:
         CONTACT_SEARCH:@{@"sUser":[DatabaseModel queryUserInfo][@"UID"],@"tUser":self.cellDictionary[@"UID"]}:0
         onCompletion:^(NSDictionary *getReuslt) {
             
             if ([getReuslt[@"success"] isEqualToString:@"true"] && [getReuslt[@"statusCode"] isEqualToString:@"1"])  {
                 //display finished status
                 self.HUD.labelText = @"Done";
                 [self.contactAddBtn setTitle:@"Added" forState:UIControlStateNormal];
             }
             else if ([getReuslt[@"success"] isEqualToString:@"false"] && [getReuslt[@"statusCode"] isEqualToString:@"0"]){
                 //display error message
                 [SystemUIViewControllerModel aLertViewDisplay:getReuslt[@"message"]:@"Notices":self:@"OK":nil];
             }
             else if ([getReuslt[@"success"] isEqualToString:@"false"] && [getReuslt[@"statusCode"] isEqualToString:@"3"]){
                 //display the network error
                 [SystemUIViewControllerModel aLertViewDisplay:getReuslt[@"message"]:@"Notices":self:@"OK":nil];
             }
             dispatch_async(dispatch_get_main_queue(), ^(void){
                 [self.HUD hide:YES];
             });
         }];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
