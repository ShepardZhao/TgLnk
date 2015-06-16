//
//  SystemUIViewController.m
//  TgLnk
//
//  Created by shepard zhao on 12/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "SystemUIViewControllerModel.h"

@interface SystemUIViewControllerModel ()

@end

@implementation SystemUIViewControllerModel

// set animated loading view
- (void)setLoadingAnimationViewForWebView:(UIViewController *)myViewController {
  loadingView = [[UIView alloc]
      initWithFrame:CGRectMake(myViewController.view.frame.origin.x,
                               myViewController.view.frame.origin.y,
                               myViewController.view.frame.size.width,
                               myViewController.view.frame.size.height)];

  loadingView.opaque = NO;
  loadingView.backgroundColor = RGB2UICOLOR(245, 245, 245, 0.6);

  // indicator on loading View

  indicator = [[UIActivityIndicatorView alloc]
      initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

  indicator.frame =
      CGRectMake(round((loadingView.frame.size.width - 25) / 2),
                 round((loadingView.frame.size.height - 25) / 2), 25, 25);

  [indicator startAnimating];

  [loadingView addSubview:indicator];
}

// get animated loading view
- (UIView *)getLoadingAnimationViewForWebView {
  return loadingView;
}

// get alert

+ (void)aLertViewDisplay:(NSString *)message
                        :(NSString *)title
                        :(id)delegate
                        :(NSString *)cancelButtonTitle
                        :(NSString *)otherButtonTitle {
  UIAlertView *alert =
      [[UIAlertView alloc] initWithTitle:title
                                 message:message
                                delegate:delegate
                       cancelButtonTitle:cancelButtonTitle
                       otherButtonTitles:otherButtonTitle, nil];

  [alert show];
}

// hide UINavgation bar hideBottomHairline

+ (void)hideBottomHairline:(UINavigationBar *)navigationBar {
  [navigationBar hideBottomHairline];
}

+ (void)pullDownAndRefresh:(NSObject *)getbject : (id)getid {
}

// impletement image cache
+ (void)imageCache:(UIImageView *)objectUiImageView :(NSString *)imageUrl {
  [objectUiImageView
      sd_setImageWithURL:
          [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", DOMAIN_NAME,
                                                          imageUrl]]
        placeholderImage:[UIImage imageNamed:@"placeHolder"]];
}

/**
 **fix roate
 **/


+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}




/**
 **end
 **/

/**
 **hide tab bar
 **/

+ (void)hideTabBar:(UITabBarController *)tabBarController {
  CATransition *animation = [CATransition animation];

  [animation setDuration:0.3];  // Animate for a duration of 0.3 seconds
  [animation
      setType:kCATransitionPush];  // New image will push the old image off
  [animation setSubtype:kCATransitionFromBottom];  // Current image will slide
                                                   // off to the left, new image
                                                   // slides in from the right
  [animation
      setTimingFunction:[CAMediaTimingFunction
                            functionWithName:kCAMediaTimingFunctionEaseIn]];

  [[tabBarController.tabBar layer] addAnimation:animation forKey:nil];
  [tabBarController.tabBar setHidden:YES];
}

/**
 **end
 **/

/**
 **show tab bar
 **/
+ (void)showTabBar:(UITabBarController *)tabBarController {
  CATransition *animation = [CATransition animation];

  [animation setDuration:0.3];  // Animate for a duration of 0.3 seconds
  [animation
      setType:kCATransitionPush];  // New image will push the old image off
  [animation setSubtype:kCATransitionFromTop];  // Current image will slide off
                                                // to the left, new image slides
                                                // in from the right
  [animation
      setTimingFunction:[CAMediaTimingFunction
                            functionWithName:kCAMediaTimingFunctionEaseIn]];

  [[tabBarController.tabBar layer] addAnimation:animation forKey:nil];
  [tabBarController.tabBar setHidden:NO];
}

/**
 **end
 **/

/**
 *  return style button
 *  @param button
 */
+ (UIButton*) styleButton:(UIButton*)button cornerRadius:(CGFloat)radius  borderWidth:(CGFloat)borderWidth borderColor:(CGColorRef)borderColor  {
    button.layer.cornerRadius = radius;
    button.layer.borderWidth = borderWidth;
    button.layer.borderColor = borderColor;
    return button;
}



/**
 *  return circle image
 *
 *  @param uiImageView
 *  @param boardRequest
 *
 *  @return UIImageView
 */

+(UIImageView*) circleImage:(UIImageView*) uiImageView : (int) boardRequest{
    
    dispatch_async(dispatch_get_main_queue(),^{
        
        uiImageView.layer.cornerRadius = uiImageView.frame.size.height /2;
        uiImageView.layer.masksToBounds = YES;
        uiImageView.alpha=1.0;
        if (boardRequest==1) {
            uiImageView.layer.borderWidth = 2;
            uiImageView.layer.borderColor = [ RGB2UICOLOR(255,255,255,1.0) CGColor];
        }
        
    });
    return uiImageView;
}

/**
 *  return scaled and compressed UIImage
 *
 *  @param image   Source UIImage
 *  @param quality The quality of compress by default should be 0.5, but you can custom
 *  @param newSize The CGSize for crop
 *
 *  @return UIImage - NSData
 */


+(NSData*) compressUIImage:(UIImage*)image quality:(double)quality scaledToSize:(CGSize)newSize{
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //compress
    NSData *imageData = UIImageJPEGRepresentation(newImage, quality);
 
    return imageData;
}



@end
