//
//  webServicesNsObject.h
//  TgLnk
//
//  Created by shepard zhao on 19/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "MBProgressHUD.h"
#import "NsUserDefaultModel.h"
#import "SysNsObject.h"
#import <UIKit/UIView.h>

typedef void(^RequestDictionaryCompletionHandler)(NSDictionary*);
@interface WebServicesNsObject : NSObject<MBProgressHUDDelegate>
+ (void)GET_HTTP_METHOD:(NSString*)url : (NSDictionary*)parameters : (int)loading onCompletion:(RequestDictionaryCompletionHandler)complete;
+ (void)POST_HTTP_METHOD:(NSString*)url : (NSDictionary*)parameters : (int)loading onCompletion:(RequestDictionaryCompletionHandler)complete;
+ (void)PUT_HTTP_METHOD:(NSString*)url : (NSDictionary*)parameters : (int)loading onCompletion:(RequestDictionaryCompletionHandler)complete;
+ (void)DELETE_HTTP_METHOD:(NSString*)url : (NSDictionary*)parameters : (int)loading onCompletion:(RequestDictionaryCompletionHandler)complete;

+(void)uploadImageNormal:(NSData*)uiimageData paramters:(NSDictionary*)paramters  baseUrl:(NSString*)baseUrl onCompletion:(RequestDictionaryCompletionHandler)complete;
+(void) uploadImageByProgressBar:(UIViewController*)UiViewControllerDelegate :(NSMutableArray*) imageDataArray : (NSDictionary*)paramters :(NSString*)baseUrl onCompletion:(RequestDictionaryCompletionHandler)complete;
@end
