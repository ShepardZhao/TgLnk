//
//  NsUserDefaultModel.m
//  iafamily
//
//  Created by shepard zhao on 23/08/2014.
//  Copyright (c) 2014 com.xunzhao. All rights reserved.
//

#import "NsUserDefaultModel.h"

@implementation NsUserDefaultModel:NSUserDefaults

+(void)setUserDefault:(NSDictionary*) data : (NSString*) keyname{
    
     NSData *getdata = [NSKeyedArchiver archivedDataWithRootObject:data];

    [[NsUserDefaultModel nsUserDefaultSignton] setObject:getdata forKey:keyname];
    
    [[NsUserDefaultModel nsUserDefaultSignton] synchronize];
}


//create NsUserDefault instance
+(NSUserDefaults*) nsUserDefaultSignton{
    NSUserDefaults* session = [NSUserDefaults standardUserDefaults];
    return session;
}

//remove specifal key name from NsUserDefault
+(void) removeKeyFromSession:(NSString*) keyName{
    
    [[NsUserDefaultModel nsUserDefaultSignton] removeObjectForKey:keyName];

}


//get userDictionary (collection format) from NsUserDefault
+(NSString*) getUserIDFromCurrentSession{
 
    NSDictionary* getTempID = [NsUserDefaultModel getUserDictionaryFromSession];
    

    return getTempID[@"UID"];
    
}


//get currentUserId from NsUserDefault
+(NSDictionary*) getUserDictionaryFromSession{
    
    NSData *userDictionary = [[NsUserDefaultModel nsUserDefaultSignton] objectForKey:@"userInfoLibrary"];
    NSDictionary *arr = (NSDictionary*)[NSKeyedUnarchiver unarchiveObjectWithData:userDictionary];
    
    return arr;
}



//remove the all key from the NsUserDefault
+(void) removeAllKeyFromSession{
    NSDictionary *defaultsDictionary = [[NsUserDefaultModel nsUserDefaultSignton] dictionaryRepresentation];
    for (NSString *key in [defaultsDictionary allKeys]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }

}




//set the  quota
+(void)setNetworkQuota:(double)bytes{

  [[NsUserDefaultModel nsUserDefaultSignton] setObject:[NSString stringWithFormat:@"%f",bytes] forKey:@"Bytes"];

}



//get the quota

+(double)getNetworkQuota{
    
    
    NSString *sendBytes = [[NsUserDefaultModel nsUserDefaultSignton] objectForKey:@"Bytes"];
    
    return [sendBytes doubleValue];
 
    
}



//set gps enable
+(void)setGPSEnableStatus:(NSString*)GPSstatus{
    [[NsUserDefaultModel nsUserDefaultSignton] setObject:[NSString stringWithFormat:@"%@",GPSstatus] forKey:@"gpsStatus"];

}

//get gps status
+(NSString*)getGPSEnableStatus{
     NSString* getgpsStatus = [[NsUserDefaultModel nsUserDefaultSignton] objectForKey:@"gpsStatus"];
    return getgpsStatus;
}




//get current data from NsUserDefault

+(NSMutableArray*)getCurrentData:(NSString*)forName {
    
    NSData *userDictionary = [[NsUserDefaultModel nsUserDefaultSignton] objectForKey:forName];
    NSMutableArray *arr = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:userDictionary];
    
    return arr;


}





@end

