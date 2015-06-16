//
//  QRAnalysisNSObject.h
//  TgLnk
//
//  Created by Shepard zhao on 15/06/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRAnalysisNSObject : NSObject

/**
 *  Pass the QR url and get the core string, i.e, 10000000 is QR stylem and shepard_zhao is userID style
 *
 *  @param url QR url String
 *
 *  @return NSString
 */
+ (NSString *)QRUrlAnalysis:(NSString*)url;







@end
