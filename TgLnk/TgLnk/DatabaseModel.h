//
//  DatabaseModel.h
//  TgLnk
//
//  Created by shepard zhao on 25/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "FMDB/FMDatabaseAdditions.h"

@interface DatabaseModel : NSObject

/**
 *  this method is returning the db connection
 *
 *  @return db connection
 */
+ (id)dbConnection;

/**
 *  db create the tables
 */
+ (void)createTables;

/**
 *  create or update user table
 *
 *  @param noticeBoardNSDictionary
 */
+ (void)createOrUpdateBoardTable:(NSMutableArray *)noticeBoardNSDictionary;

/**
 *  Create or update post table
 */
+ (void)createOrUpdatePostTable:(NSMutableArray*)getPostDictionary;

/**
 *  Create user table or update user table
 *
 *  @param userInfo is presenting the user information
 */
+ (void)createOrUpdateUserTable:(NSDictionary *)userInfo;

/**
 *  QUERY POST BY DIFFERENT QUERY TYPE
 *
 *  @return NSMutableArray of posts
 */
+ (NSMutableArray*)queryPost:(NSString*)queryType : (NSString*)queryValue;

/**
 *
 *
 *  @param boardDictionary
 *
 *  @return NSMutableArray of user login status
 */
+ (NSMutableArray*)queryBoard;

/**
 *  check user login status
 *
 *  @return YES if user login else NO
 */
+ (BOOL)queryUserLoginStatus;

/**
 *  query user information
 *
 *  @return return value description
 */
+ (NSDictionary *)queryUserInfo;


/**
 *  update current logined user status
 *
 *  @param userID
 *
 *  @return YES OR NO
 */
+(BOOL) signOutCurrentUser:(NSString *)userID;


/**
 *  update the user Avatar
 *
 *  @param uiImageNSData update user avatar
 *  @param userID        UID as the paramter that will keep the object unique identity
 *  @return BOOL YES OR NO
 */
+(BOOL) updateUserAvatar:(NSData *)uiImageNSData userID:(NSString *)userID;

@end
