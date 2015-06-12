//
//  NetworkCheckModel.m
//  TgLnk
//
//  Created by Shepard zhao on 11/06/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "NetworkCheckModel.h"
#import "Reachability.h"
@implementation NetworkCheckModel

/**
 * network connection dectection 
 **/

+ (BOOL)isNetworkConnection{
    BOOL isConnected = YES;
    
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    
    NSParameterAssert([reach isKindOfClass:[Reachability class]]);
    
    NetworkStatus status = [reach currentReachabilityStatus];
    
   
    if (status == ReachableViaWiFi){
        isConnected = YES;
    }else if (status == ReachableViaWWAN){
        isConnected = YES;
    }else{isConnected = NO;}
    
    return isConnected;
}




@end
