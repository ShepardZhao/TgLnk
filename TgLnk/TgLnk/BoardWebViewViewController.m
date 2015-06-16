//
//  BoardWebViewViewController.m
//  TgLnk
//
//  Created by shepard zhao on 12/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "BoardWebViewViewController.h"

@interface BoardWebViewViewController ()
@end

@implementation BoardWebViewViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // inital SystemUIViewController
  sysUICtr = [[SystemUIViewControllerModel alloc] init];
  [sysUICtr setLoadingAnimationViewForWebView:self];
  [self followScrollView:self.qrWebView];

  requestLoad =
    [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.105:3000"]];
  self.qrWebView.scrollView.delegate = self;

  [self.qrWebView.scrollView addLegendHeaderWithRefreshingBlock:^{
    [self.qrWebView loadRequest:requestLoad];

    dispatch_after(
        dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
          [self.qrWebView.scrollView.header endRefreshing];
        });

  }];

  [self.qrWebView loadRequest:requestLoad];

  // db initial
  self.db = [[DatabaseModel alloc] init];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
  // set up loading view

  [self.view addSubview:[sysUICtr getLoadingAnimationViewForWebView]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  [[sysUICtr getLoadingAnimationViewForWebView] removeFromSuperview];
}

- (BOOL)webView:(UIWebView *)webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
                navigationType:(UIWebViewNavigationType)navigationType {
    /*
    
  if ([request.URL.scheme isEqualToString:@"follow"]) {
    if ([self.db queryBoardByloginUser:[SysNsObject splitQuery:request.URL.query]]) {
      // alert the user that this noticeboard already been subscribled
      [SystemUIViewControllerModel aLertViewDisplay:@"You already subscrible this noticeboard" :@"Notices" :self :@"OK" :nil];

    } else {
      // otherwise, the app should ask the user login first then.
      [self performSegueWithIdentifier:@"loginSegue" sender:self];
    }
    return NO;
  }

  else if ([request.URL.scheme isEqualToString:@"post"]) {
    [self performSegueWithIdentifier:@"postSegue" sender:self];

    return NO;
  }
     */

  return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  [SystemUIViewControllerModel aLertViewDisplay:@"Could't open this page":@"Notices":self:@"OK":nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self showNavBarAnimated:NO];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
  // This enables the user to scroll down the navbar by tapping the status bar.
  [self showNavbar];

  return YES;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"postSegue"]) {
    BoardPostTableViewController *postCtr =
        (BoardPostTableViewController *)segue.destinationViewController;
  }
}

@end
