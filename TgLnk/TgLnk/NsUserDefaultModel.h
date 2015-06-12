//
//  NsUserDefaultModel.h
//  iafamily
//
//  Created by shepard zhao on 23/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NsUserDefaultModel : NSUserDefaults
+(NSUserDefaults*) nsUserDefaultSignton;
+(void) removeKeyFromSession:(NSString*) keyName;
+(void) removeAllKeyFromSession;
+(NSString*) getUserIDFromCurrentSession;
+(NSDictionary*) getUserDictionaryFromSession;
+(void)setUserDefault:(NSDictionary*) data : (NSString*) keyname;



//set network quota
+(void)setNetworkQuota:(double)bytes;


//get network quota
+(double)getNetworkQuota;

//set gps enable status
+(void)setGPSEnableStatus:(NSString*)GPSstatus;

//get gps enable status
+(NSString*)getGPSEnableStatus;

+(NSMutableArray*)getCurrentData:(NSString*)forName;




@end
