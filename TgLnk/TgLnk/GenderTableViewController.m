//
//  GenderTableViewController.m
//  TgLnk
//
//  Created by shepard zhao on 20/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "GenderTableViewController.h"

@interface GenderTableViewController () {
  int selectGender;
  BOOL haveSelectGender;
}

@end

@implementation GenderTableViewController

- (void)viewDidLoad {

  [super viewDidLoad];
}


- (IBAction)genderDoneBtn:(id)sender {

  if (haveSelectGender) {
    if (selectGender == 0) {
      self.gender = [NSString stringWithFormat:@"%@", @"male"];
    } else if (selectGender == 1) {
      self.gender = [NSString stringWithFormat:@"%@", @"female"];
    }

    NSDictionary *dictionary =
        [NSDictionary dictionaryWithObjectsAndKeys:self.gender, @"GENDER", nil];
   // [self.delegate passData:dictionary];

    [self.navigationController
        popToViewController:[self.navigationController.viewControllers
                                objectAtIndex:0]
                   animated:YES];

  } else {

    [SystemUIViewControllerModel aLertViewDisplay:@"You have to select at least one gender" :@"notices" :nil :@"OK" :nil];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  if (section == 0) {
    return 2;
  } else {
    return 0;
  }
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  for (id algoPath in [tableView indexPathsForVisibleRows]) {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:algoPath];
    cell.accessoryType = UITableViewCellAccessoryNone;

    if (algoPath == indexPath) {
      selectGender = (int)indexPath.row;
      haveSelectGender = YES;
      cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
  }

  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView
dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#>
forIndexPath:indexPath];

    // Configure the cell...

    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath
*)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath]
withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the
array, and add a new row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath
*)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath
*)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
