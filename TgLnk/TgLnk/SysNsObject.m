//
//  SysNsObject.m
//  TgLnk
//
//  Created by shepard zhao on 19/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "SysNsObject.h"

@implementation SysNsObject
/**
 *  regex for http check
 *
 *  @param BOOL
 *
 *  @return return YES or NO
 */
+ (BOOL)getHTTPValidationByNSRegularExpression:(NSString *)str {
  BOOL isMatch = [str isMatch:RX(HTTP_REGEX)];
  return isMatch;
}

/**
 *  regex for email check
 *
 *  @param BOOL
 *
 *  @return return YES or NO
 */
+ (BOOL)getEmailCheckRegularExpression:(NSString *)str {
  BOOL isMatch = [str isMatch:RX(EMAIL_REGEX)];
  return isMatch;
}

/**
 *  regex for user id
 *
 *  @param BOOL
 *
 *  @return YES or NO
 */
+ (BOOL)getUserIDRegularExpression:(NSString *)str {
  BOOL isMatch = [str isMatch:RX(USER_ID_REGEX)];
  return isMatch;
}

/**
 *  md5 hashing
 *
 *  @param string
 *
 *  @return nsstring
 */
+ (NSString *)md5Hash:(NSString *)string {
  const char *cStr = [string UTF8String];
  unsigned char digest[CC_MD5_DIGEST_LENGTH];
  CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);  // This is the md5 call

  NSMutableString *output =
      [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

  for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    [output appendFormat:@"%02x", digest[i]];

  return output;
}

/**
 *  get devices name
 *
 *  @return get string name that displays the device's name
 */
+ (NSString *)getDeviceName {
  struct utsname systemInfo;
  uname(&systemInfo);

  return [NSString stringWithCString:systemInfo.machine
                            encoding:NSUTF8StringEncoding];
}

/**
 *  querying the url paramters then returns the object
 *
 *  @param query URL along with query string
 *
 *  @return NSDictionary
 */
+ (NSDictionary *)splitQuery:(NSString *)query {
  if (!query || [query length] == 0) return nil;
  NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
  for (NSString *parameter in [query componentsSeparatedByString:@"&"]) {
    NSRange range = [parameter rangeOfString:@"="];
    if (range.location != NSNotFound)
      [parameters
          setValue:[[parameter substringFromIndex:range.location + range.length]
                       stringByReplacingPercentEscapesUsingEncoding:
                           NSASCIIStringEncoding]
            forKey:[[parameter substringToIndex:range.location]
                       stringByReplacingPercentEscapesUsingEncoding:
                           NSASCIIStringEncoding]];
    else
      [parameters
          setValue:[[NSString alloc] init]
            forKey:[parameter stringByReplacingPercentEscapesUsingEncoding:
                                  NSASCIIStringEncoding]];
  }
  return [parameters copy];
}

/**
 *  return unformated date
 *
 *  @return date with unformated
 */
+(NSString*)getCurrentDate{
    NSDate *localDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd_HH-mm-ss";
    
    NSString *dateString = [dateFormatter stringFromDate: localDate];
    return dateString;
}

@end
