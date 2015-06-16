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
    
  [[self getAFHTTPRequestOperationManager] GET:url
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
                  if (complete) complete([[NSDictionary alloc] initWithObjectsAndKeys:@"false",@"success",WEBSERVER_ERROR_MESSAGE,@"message",@"3",@"statusCode",nil]);
              }
          });
    }];
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
  [[self getAFHTTPRequestOperationManager] POST:url
      parameters:parameters
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          dispatch_async(dispatch_get_main_queue(), ^() {
            if (complete) {
              if (complete) complete(responseObject);
            }
          });

      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {

          dispatch_async(dispatch_get_main_queue(), ^() {
              if (complete) {
                  if (complete) complete([[NSDictionary alloc] initWithObjectsAndKeys:@"false",@"success",WEBSERVER_ERROR_MESSAGE,@"message",@"3",@"statusCode",nil]);
              }
          });
      
      }];
}



/**
 *  Normal PUT Method
 *
 *  @param url
 *  @param parameters
 *  @param loading
 *  @param complete
 */
+ (void)PUT_HTTP_METHOD:(NSString *)url
                        :(NSDictionary *)parameters
                        :(int)loading
            onCompletion:(RequestDictionaryCompletionHandler)complete {
    [[self getAFHTTPRequestOperationManager] PUT:url
                                       parameters:parameters
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                              NSLog(@"%@",responseObject);
                                                  dispatch_async(dispatch_get_main_queue(), ^() {
                                                      if (complete) {
                                                          if (complete) complete(responseObject);
                                                      }
                                                  });
                                              }
                                          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                              dispatch_async(dispatch_get_main_queue(), ^() {
                                                  if (complete) {
                                                      if (complete) complete([[NSDictionary alloc] initWithObjectsAndKeys:@"false",@"success",WEBSERVER_ERROR_MESSAGE,@"message",@"3",@"statusCode",nil]);
                                                  }
                                              });
                                              
                                          }];
    
}



/**
 *  Normal DELETE Method
 *
 *  @param url
 *  @param parameters
 *  @param loading
 *  @param complete
 */
+ (void)DELETE_HTTP_METHOD:(NSString *)url
                       :(NSDictionary *)parameters
                       :(int)loading
           onCompletion:(RequestDictionaryCompletionHandler)complete {
    [[self getAFHTTPRequestOperationManager] DELETE:url
                                      parameters:parameters
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                 dispatch_async(dispatch_get_main_queue(), ^() {
                                                     if (complete) {
                                                         if (complete) complete(responseObject);
                                                     }
                                                 });
                                         }
                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             
                                             dispatch_async(dispatch_get_main_queue(), ^() {
                                                 if (complete) {
                                                     if (complete) complete([[NSDictionary alloc] initWithObjectsAndKeys:@"false",@"success",WEBSERVER_ERROR_MESSAGE,@"message",@"3",@"statusCode",nil]);
                                                 }
                                             });
                                             
                                         }];
    
}






/**
 *  Get instance of AFHTTPRequestOperationManager
 *
 *  @return AFHTTPRequestOperationManager
 */
+ (AFHTTPRequestOperationManager *)getAFHTTPRequestOperationManager {
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    return manager;
}



/**
 *  upload image
 *
 *  @param UiViewControllerDelegate
 *  @param paramters                paramters that used to upload
 *  @param baseUrl                  upload the baseUrl
 *  @param complete                 complete block
 */


+(void)uploadImageNormal:(NSData*)uiimageData paramters:(NSDictionary*)paramters  baseUrl:(NSString*)baseUrl onCompletion:(RequestDictionaryCompletionHandler)complete{

    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:baseUrl parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
    
        [formData appendPartWithFileData:uiimageData
                                    name:[NSString stringWithFormat:@"avatar"]
                                fileName:[NSString stringWithFormat:@"avatar_%@",paramters[@"UID"]]
                                mimeType:@"image/jpeg"];
    } error:nil];

    
    
    //send the request
   [[[self getAFHTTPRequestOperationManager] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //if successfully gets responseObject | GCD
        dispatch_async(dispatch_get_main_queue(), ^(){
            if (complete) {
                if (complete) complete(responseObject);
            }
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (complete) {
            if (complete) complete([[NSDictionary alloc] initWithObjectsAndKeys:@"false",@"success",WEBSERVER_ERROR_MESSAGE,@"message",@"3",@"statusCode",nil]);
        }
    }] start];
    
    
    

}


/**
 *  Specific post - image upload by progress bar
 *
 *  @param UiViewControllerDelegate 
 *  @param imageDataArray
 *  @param paramters
 *  @param baseUrl
 *  @param complete
 */
+(void) uploadImageByProgressBar:(UIViewController*)UiViewControllerDelegate :(NSMutableArray*) imageDataArray : (NSDictionary*)paramters :(NSString*)baseUrl onCompletion:(RequestDictionaryCompletionHandler)complete{
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:UiViewControllerDelegate.view animated:YES];
    HUD.labelText = @"uploading...";
    HUD.mode = MBProgressHUDModeAnnularDeterminate;
    
    
    
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
    AFHTTPRequestOperation *requestOperation = [[self getAFHTTPRequestOperationManager] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
