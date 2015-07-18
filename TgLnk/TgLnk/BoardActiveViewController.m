//
//  BoardActiveViewController.m
//  TgLnk
//
//  Created by Shepard zhao on 15/06/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "BoardActiveViewController.h"

@interface BoardActiveViewController ()

@end

@implementation BoardActiveViewController


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.activeCodeText becomeFirstResponder];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Active Board";
    [SystemUIViewControllerModel imageCache:self.uiboardImage :self.boardArray[@"BIMAGE"]:0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)activeBtn:(id)sender {
    if ([self.activeCodeText.text isEqualToString:@""]) {
        [SystemUIViewControllerModel aLertViewDisplay:@"Please input the active code before do activtion" :@"Notices" :self :@"OK" :nil];
    }
    else{
        
        self.HUD = [MBProgressHUD showHUDAddedTo:self.parentViewController.view animated:YES];
        self.HUD.delegate = self;
        self.HUD.labelText = @"Activating...";
        //do activtion
        [WebServicesNsObject PUT_HTTP_METHOD:NOTICESBOARD_ACTIVE :@{@"noticeBoardID":self.boardArray[@"BID"],@"activeCode":self.activeCodeText.text} :1 onCompletion:^(NSDictionary *getResult) {
     
            if ([getResult[@"success"] isEqualToString:@"true"] && [getResult[@"statusCode"] isEqualToString:@"1"]) {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.HUD.labelText = @"Activated";

                    [self.HUD hide:YES afterDelay:1];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        //head to detail board controller
                        
                        [self performSegueWithIdentifier:@"gotToBoardDetailSegue" sender:self];
                        
                    });
                    
                    
                    
                });
                
            }
            
            else if ([getResult[@"success"] isEqualToString:@"false"] && [getResult[@"statusCode"] isEqualToString:@"0"]){
                [self.HUD hide:YES];
                [SystemUIViewControllerModel aLertViewDisplay:getResult[@"message"]:@"Notices" :self :@"OK" :nil];
            }
            
            else if ([getResult[@"success"] isEqualToString:@"false"] && [getResult[@"statusCode"] isEqualToString:@"3"]){
                [self.HUD hide:YES];
                [SystemUIViewControllerModel aLertViewDisplay:getResult[@"message"]:@"Notices" :self :@"OK" :nil];

            }
            
            
        }];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"gotToBoardDetailSegue"]) {
        BoardDetailTableViewController *boardCtrl = (BoardDetailTableViewController *)segue.destinationViewController;
        boardCtrl.requestType = @"requestByBoard";
        boardCtrl.requestID = self.boardArray[@"BID"];
        
    }
    
}


@end
