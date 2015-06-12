//
//  SysNsObject.h
//  TgLnk
//
//  Created by shepard zhao on 19/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegExCategories.h"
#import <CommonCrypto/CommonDigest.h>
#import <sys/utsname.h>

@interface SysNsObject : NSObject


/**
 *  get obejct regex
 *
 *  @param str expression
 *
 *  @return YES OR NO
 */
+ (BOOL)getHTTPValidationByNSRegularExpression:(NSString *)str;

/**
 *  check email express
 *
 *  @param str that needs to be verified
 *
 *  @return YES OR NO
 */
+(BOOL)getEmailCheckRegularExpression:(NSString*)str;

// get user id regex
/**
 *  check user regular expression
 *
 *  @param str that needs to be verified
 *
 *  @return YES OR NO
 */
+(BOOL)getUserIDRegularExpression:(NSString*)str;

/**
 *  md5 hashing
 *
 *  @param string that needs to be hashed
 *
 *  @return md5 hash
 */
+ (NSString *)md5Hash:(NSString *)string;


/**
 *  device name
 *
 *  @return Model name
 */
+ (NSString*) getDeviceName;



/**
 *  querying the url paramters then returns the object
 *
 *  @param query URL along with query string
 *
 *  @return NSDictionary
 */

+(NSDictionary*)splitQuery:(NSString*)query;

/**
 *  return unformated date
 *
 *  @return date with unformated
 */
+(NSString*)getCurrentDate;



@end
