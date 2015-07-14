//
//  SystemUIViewController.h
//  TgLnk
//
//  Created by shepard zhao on 12/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationBar+Addition.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface SystemUIViewControllerModel : UIViewController{
    UIView *loadingView;
    UIActivityIndicatorView *indicator;
}
//set animated loading view
- (void)setLoadingAnimationViewForWebView:(UIViewController*)myViewController;
//get animated loading view
- (UIView*)getLoadingAnimationViewForWebView;
//display alert
+ (void)aLertViewDisplay:(NSString *)message
                        :(NSString *)title
                        :(id)delegate
                        :(NSString *)cancelButtonTitle
                        :(NSString *)otherButtonTitle;
//hiden the navigationBar hair line
+(void)hideBottomHairline:(UINavigationBar*)navigationBar;


//cache images
+(void)imageCache:(UIImageView *)objectUiImageView
                 :(NSString*) imageUrl :(int)placerHolderType;

//fix rotate issue
+ (UIImage *)fixOrientation:(UIImage *)aImage;

//hide tabBar controller
+ (void) hideTabBar:(UITabBarController *) tabBarController;

//radius button
+ (UIButton*) styleButton:(UIButton*)button cornerRadius:(CGFloat)radius  borderWidth:(CGFloat)borderWidth borderColor:(CGColorRef)borderColor;

//return circle image
+(UIImageView*) circleImage:(UIImageView*) uiImageView : (int) boardRequest;

//return scaled and compressed image
+(NSData*) compressUIImage:(UIImage*)image quality:(double)quality scaledToSize:(CGSize)newSize;

//alert banner
+(void) setAlertBanner:(UIViewController *)viewController message : (NSString *)message selector : (SEL)selector;



@end
