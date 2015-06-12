//
//  DOBTableViewController.m
//  TgLnk
//
//  Created by shepard zhao on 20/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "DOBTableViewController.h"

@interface DOBTableViewController (){

    NSString *dob;
}

@end

@implementation DOBTableViewController


-(BOOL)textFieldShouldReturn:(UITextField *)Done {
    [Done resignFirstResponder];
    return YES;
}
- (IBAction)dobDoneBtn:(id)sender {
    if ([self.dayTextField.text isEqualToString:@""]) {
        [SystemUIViewControllerModel aLertViewDisplay:@"The day cannot be empty" :@"Notices" :self :@"Ok" :nil];
    }
    else if([self.monthTextField.text isEqualToString:@""]){
        [SystemUIViewControllerModel aLertViewDisplay:@"The month cannot be empty" :@"Notices" :self :@"Ok" :nil];
    }
    else if([self.yearTextField.text isEqualToString:@""]){
        [SystemUIViewControllerModel aLertViewDisplay:@"The year cannot be empty" :@"Notices" :self :@"Ok" :nil];
    }
    else{

        dob = [NSString stringWithFormat:@"%@-%@-%@",self.dayTextField.text,self.monthTextField.text,self.yearTextField.text];

        NSDictionary *dictionary=[NSDictionary  dictionaryWithObjectsAndKeys:dob,@"DOB",self.dayTextField.text,@"DAY",self.monthTextField.text,@"MONTH",self.yearTextField.text,@"YEAR",nil];
        //[self.delegate passData:dictionary];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];

    }
    
    
    
}

- (void)viewDidLoad {
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    
    [super viewDidLoad];
}

-(void) hideKeyboard:(UIGestureRecognizer*)tapGestureRecognizer{
    if (!CGRectContainsPoint([self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]].frame, [tapGestureRecognizer locationInView:self.tableView]))
    {
        [self.view endEditing:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section==0){
        return 3;
    }else{return 0;}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag==0 || textField.tag==1) {
        if (textField.text.length >= 2 && range.length == 0)
        {
            return NO; // return NO to not change text
        }
        else
        {return YES;}
    }
    else {
    
        if (textField.text.length >= 4 && range.length == 0)
        {
            return NO; // return NO to not change text
        }
        else
        {return YES;}

    }
   
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
