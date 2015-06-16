//
//  QRAnalysisNSObject.m
//  TgLnk
//
//  Created by Shepard zhao on 15/06/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "QRAnalysisNSObject.h"
#import "DatabaseModel.h"
@implementation QRAnalysisNSObject

/**
 *  Pass the QR url and get the core string, i.e, 10000000 is QR stylem and shepard_zhao is userID style
 *
 *  @param url QR url String
 *
 *  @return NSString
 */
+ (NSString *)QRUrlAnalysis:(NSString*)url{
    // here we assume that url is valiaded for project using
    NSArray *array = [url componentsSeparatedByString:DOMAIN_NAME_QR];
    
    NSLog(@"%@",array);
    
    return [array objectAtIndex:1];
}



@end
