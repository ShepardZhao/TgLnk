//
//  webServicesNsObject.m
//  TgLnk
//
//  Created by shepard zhao on 19/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "WebServicesNsObject.h"

@implementation WebServicesNsObject



/**
 *  Normal Get Method
 *
 *  @param url
 *  @param parameters
 *  @param loading
 *  @param complete
 */
+ (void)GET_HTTP_METHOD:(NSString *)url
                       :(NSDictionary *)parameters
                       :(int)loading
           onCompletion:(RequestDictionaryCompletionHandler)complete {
    
  [[WebServicesNsObject getAFHTTPRequestOperationManager] GET:url
      parameters:parameters
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^() {
          if (complete) {
            if (complete) complete(responseObject);
          }
        });

      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          dispatch_async(dispatch_get_main_queue(), ^(){
              if (complete) {
                  if (complete) complete([[NSDictionary alloc] initWithObjectsAndKeys:@"false",@"success",WEBSERVER_ERROR_MESSAGE,@"message",nil]);
              }
          });
    }];
}

+ (AFHTTPRequestOperationManager *)getAFHTTPRequestOperationManager {
  AFHTTPRequestOperationManager *manager =
      [AFHTTPRequestOperationManager manager];
  return manager;
}



/**
 *  Normal Post Method
 *
 *  @param url
 *  @param parameters
 *  @param loading
 *  @param complete
 */
+ (void)POST_HTTP_METHOD:(NSString *)url
                        :(NSDictionary *)parameters
                        :(int)loading
            onCompletion:(RequestDictionaryCompletionHandler)complete {
  [[WebServicesNsObject getAFHTTPRequestOperationManager] POST:url
      parameters:parameters
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"success"] isEqualToString:@"true"]) {
          dispatch_async(dispatch_get_main_queue(), ^() {
            if (complete) {
              if (complete) complete(responseObject);
            }
          });
        }

      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {

          dispatch_async(dispatch_get_main_queue(), ^() {
              if (complete) {
                  if (complete) complete([[NSDictionary alloc] initWithObjectsAndKeys:@"false",@"success",WEBSERVER_ERROR_MESSAGE,@"message",nil]);
              }
          });
      
      }];
}





/**
 *  Specific post - with image upload
 *
 *  @param UiViewControllerDelegate 
 *  @param imageDataArray
 *  @param paramters
 *  @param baseUrl
 *  @param complete
 */
+(void) postNote:(UIViewController*)UiViewControllerDelegate :(NSMutableArray*) imageDataArray : (NSDictionary*)paramters :(NSString*)baseUrl onCompletion:(RequestDictionaryCompletionHandler)complete{
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:UiViewControllerDelegate.view animated:YES];
    HUD.labelText = @"uploading...";
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //prepare the request
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:baseUrl parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int i=0; i<[imageDataArray count];i++) {
            if (imageDataArray[i])
            {
                
                
                [formData appendPartWithFileData:imageDataArray[i]
                                            name:[NSString stringWithFormat:@"%i",i]
                                        fileName:[NSString stringWithFormat:@"%@_%@_full_%i",[NsUserDefaultModel getUserIDFromCurrentSession], [SysNsObject getCurrentDate],i]
                                        mimeType:@"image/jpeg"];
                
            }
        }
        
    } error:nil];
    
    
    
    double __block quota=0.0f;
    
    //send the request
    AFHTTPRequestOperation *requestOperation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //if successfully gets responseObject | GCD
        dispatch_async(dispatch_get_main_queue(), ^(){
            if (complete) {
                
                if (complete) complete(responseObject);
                
            }
        });
        //GCG changes the label
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            HUD.labelText = @"Done";
            HUD.detailsLabelText = nil;
            //GCD delay executes
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:UiViewControllerDelegate.view animated:YES];
                
            });
            
            
        });
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:UiViewControllerDelegate.view animated:YES];
        
        
    }];
    
    
    
    
    //get uploading progress
    [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        double percentDone = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
        HUD.progress = percentDone;
        HUD.detailsLabelText = [NSString stringWithFormat:@"%.02f%@",(percentDone * 100),@"%"];
        
        quota+=(double)bytesWritten;
        
        
    }];
    
    
    //get downloaidng progress
    [requestOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
        quota+=(double)bytesRead;
        
        
    }];
    
    
    [requestOperation start];
    
    
    
}







@end
