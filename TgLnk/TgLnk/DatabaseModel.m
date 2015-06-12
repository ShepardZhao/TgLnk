//
//  DatabaseModel.m
//  TgLnk
//
//  Created by shepard zhao on 25/04/2015.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import "DatabaseModel.h"

@implementation DatabaseModel

+ (id)dbConnection {
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:DATABASE_FILENAME];
    //NSLog(@"%@",writableDBPath);
  FMDatabase *db = [FMDatabase databaseWithPath:DATABASE_FILENAME];

    
  return db;
}

+ (void)createTables {
  FMDatabase *db = [self dbConnection];
  if ([db open]) {
      NSString *sql_createTable = SQL_CREATE_STATEMENT;
    BOOL success = [db executeStatements:sql_createTable];
    if (success) {
      NSLog(@"%@", @"success create table");
    } else {
      NSLog(@"%@", @"error to create table");
    }
  }

  [db close];
}

+ (BOOL)queryUserLoginStatus {
  FMDatabase *db = [self dbConnection];
  BOOL loginStatus = NO;
  if ([db open]) {
    FMResultSet *s =
        [db executeQueryWithFormat:
                @"SELECT COUNT(*) FROM USER_T WHERE LOGINSTATUS = 1"];

    if ([s next]) {
      if ([s intForColumnIndex:0] > 0) {
        loginStatus = YES;
      }
    }
  }
  return loginStatus;
}

+ (void)createOrUpdateUserTable:(NSDictionary *)userInfo {
  FMDatabase *db = [self dbConnection];

  if ([db open]) {
    /**
     *  let's find out existing UID first, if exist then add it as new one,
     * otherwise update the record
     */
    FMResultSet *s =
        [db executeQueryWithFormat:@"SELECT * FROM USER_T WHERE UID = %@",
                                   userInfo[@"UID"]];
    BOOL existedUID = NO;

    while ([s next]) {
      existedUID = YES;
    }

    if (existedUID) {
      // update
      if (![db executeUpdate:
                   @"UPDATE USER_T SET " @"UNICKNAME=?,UEMAIL=?,ULOGIN_TIME=?, UAVATAR = ?"
                   @"LOGINSTATUS=? WHERE UID=?",
                   [NSString stringWithString:userInfo[@"UNICKNAME"]],
                   [NSString stringWithString:userInfo[@"UEMAIL"]],
                   [NSString stringWithString:userInfo[@"ULOGIN_TIME"]],
                    userInfo[@"UAVATAR"],@"1",
                   [NSString stringWithString:userInfo[@"UID"]]]) {
        NSLog(@"%@", db.lastErrorMessage);
      }

    } else {
     
      // insert new record
      if (![db executeUpdate:
                   @"INSERT INTO USER_T "
                   @"(UID,UNICKNAME,UEMAIL,UAVATAR,ULOGIN_TIME,LOGINSTATUS) VALUES "
                   @"(?,?,?,?,?,?)",
                   [NSString stringWithString:userInfo[@"UID"]],
                   [NSString stringWithString:userInfo[@"UNICKNAME"]],
                   [NSString stringWithString:userInfo[@"UEMAIL"]],
                    userInfo[@"UAVATAR"],
                   [NSString stringWithString:userInfo[@"ULOGIN_TIME"]],
                   @"1"]) {
        NSLog(@"%@", db.lastErrorMessage);
      }
    }
  }
  [db close];
}








/**
 *  CREATE OR UPATE THE BOARDTABLE
 *
 *  @param noticeBoardNSDictionary <#noticeBoardNSDictionary description#>
 */

+ (void)createOrUpdateBoardTable:(NSMutableArray *)noticeBoardNSDictionary {
  
  // loop the boards
    dispatch_async(dispatch_get_main_queue(), ^(void){
        FMDatabase *db = [self dbConnection];
        if ([db open]) {
        
        for (int i=0; i<[noticeBoardNSDictionary count]; i++) {
            
         //find the weather exist
            FMResultSet *s =
            [db executeQueryWithFormat: @"SELECT COUNT(*) FROM NOTICEBOARD_T WHERE BID = %@",[noticeBoardNSDictionary objectAtIndex:i][@"BID"]];
            while ([s next]) {
                if ([s intForColumnIndex:0] > 0) {

                    //if the record alreay exist then do the update progress
                    
                    if (![db executeUpdate:
                          @"UPDATE NOTICEBOARD_T SET BNAME =?, BIMAGE=?, BTIME=?, BGPS=? WHERE BID=? ",
                          [NSString stringWithString:[noticeBoardNSDictionary objectAtIndex:i][@"BNAME"]],
                          [NSString stringWithString:[noticeBoardNSDictionary objectAtIndex:i][@"BIMAGE"]],
                          [NSString stringWithString:[noticeBoardNSDictionary objectAtIndex:i][@"BTIME"]],
                          [NSString stringWithString:[noticeBoardNSDictionary objectAtIndex:i][@"BGPS"]],
                          [noticeBoardNSDictionary objectAtIndex:i][@"BID"]]) {
                        NSLog(@"%@", db.lastErrorMessage);
                    }
                    
                }
                
                else {
                    //do the insert progress
                    
                    if (![db executeUpdate:
                          @"INSERT INTO NOTICEBOARD_T (BNAME,BIMAGE,BTIME,BGPS,BID) VALUES (?,?,?,?,?) ",
                          [NSString stringWithString:[noticeBoardNSDictionary objectAtIndex:i][@"BNAME"]],
                          [NSString stringWithString:[noticeBoardNSDictionary objectAtIndex:i][@"BIMAGE"]],
                          [NSString stringWithString:[noticeBoardNSDictionary objectAtIndex:i][@"BTIME"]],
                          [NSString stringWithString:[noticeBoardNSDictionary objectAtIndex:i][@"BGPS"]],
                          [noticeBoardNSDictionary objectAtIndex:i][@"BID"]]) {
                        NSLog(@"%@", db.lastErrorMessage);
                        }
                    
                    }
                }
            
        
            //update or create new records for post table
            
            //call post table and update it
            if ([[noticeBoardNSDictionary objectAtIndex:i][@"POSTS"] count] >0) {
                [self createOrUpdatePostTable:[noticeBoardNSDictionary objectAtIndex:i][@"POSTS"]];
            }
        
            }
        }
         [db close];
    });
   
}




/**
 *  update or create new record for the post table
 *
 *  @param getPostDictionary 
 */

+ (void)createOrUpdatePostTable:(NSMutableArray*)getPostDictionary {
  FMDatabase *db = [self dbConnection];

    dispatch_async(dispatch_get_main_queue(), ^(void){
    
        if ([db open]) {
            for (int i=0; i<[getPostDictionary count]; i++) {
                FMResultSet *s =
                [db executeQueryWithFormat: @"SELECT COUNT(*) FROM POST_T WHERE PID =%@", [getPostDictionary objectAtIndex:i][@"PID"]];
                
                while ([s next]) {
                    if ([s intForColumnIndex:0] > 0) {
                        
                        //the record already exist
                        if (![db executeUpdate:
                              @"UPDATE POST_T SET BID = ?, UID = ?, PNAME =?, PIMG = ?, PEMAIL =? , PPHONE = ?, PTIME =? WHERE PID = ?",
                              [getPostDictionary objectAtIndex:i][@"BID"],
                              [NSString stringWithString:[getPostDictionary objectAtIndex:i][@"UID"]],
                              [NSString stringWithString:[getPostDictionary objectAtIndex:i][@"PNAME"]],
                              [NSString stringWithString:[getPostDictionary objectAtIndex:i][@"PIMG"]],
                              [NSString stringWithString:[getPostDictionary objectAtIndex:i][@"PEMAIL"]],
                              [NSString stringWithString:[getPostDictionary objectAtIndex:i][@"PPHONE"]],
                              [NSString stringWithString:[getPostDictionary objectAtIndex:i][@"PTIME"]],
                              [NSString stringWithString:[getPostDictionary objectAtIndex:i][@"PID"]]
                              ]) {
                            NSLog(@"%@", db.lastErrorMessage);
                        }
                        
                        
                        
                    }
                    else{
                        //the record does not exist which needs to append a new one
                        if (![db executeUpdate:
                              @"INSERT INTO POST_T (PID,BID,UID,PNAME,PIMG,PEMAIL,PPHONE,PTIME) VALUES (?,?,?,?,?,?,?,?)",
                              [NSString stringWithString:[getPostDictionary objectAtIndex:i][@"PID"]],
                              [getPostDictionary objectAtIndex:i][@"BID"],
                              [NSString stringWithString:[getPostDictionary objectAtIndex:i][@"UID"]],
                              [NSString stringWithString:[getPostDictionary objectAtIndex:i][@"PNAME"]],
                              [NSString stringWithString:[getPostDictionary objectAtIndex:i][@"PIMG"]],
                              [NSString stringWithString:[getPostDictionary objectAtIndex:i][@"PEMAIL"]],
                              [NSString stringWithString:[getPostDictionary objectAtIndex:i][@"PPHONE"]],
                              [NSString stringWithString:[getPostDictionary objectAtIndex:i][@"PTIME"]]
                              ]) {
                            NSLog(@"%@", db.lastErrorMessage);
                        }
                    }
                    
                }
                
            }
            
            }
            
        [db close];

    });
    
}

/**
 *  QUERY POST BY DIFFERENT QUERY TYPE
 *
 *  @return queryPost
 */
+ (NSMutableArray*)queryPost:(NSString*)queryType : (NSString*)queryValue{
    FMDatabase *db = [self dbConnection];
    NSMutableArray *posts = [[NSMutableArray alloc] init];

    if ([db open]) {
        FMResultSet *s;
        if ([queryType isEqualToString:BOARDID]) {
            s = [db executeQueryWithFormat:@"SELECT * FROM POST_T WHERE BID = %lu",[queryValue integerValue]];
        }
        else if ([queryType isEqualToString:UID]) {
            s = [db executeQueryWithFormat:@"SELECT * FROM POST_T WHERE UID = %@",queryValue];
        }
        else if ([queryType isEqualToString:POSTID]) {
            s = [db executeQueryWithFormat:@"SELECT * FROM POST_T WHERE POSTID = %@",queryValue];

        }
        
        while ([s next]) {
            NSDictionary *temp = [[NSDictionary alloc] initWithObjectsAndKeys:[s stringForColumn:@"BID"],@"BID",[s stringForColumn:@"PEMAIL"],@"PEMAIL",[s stringForColumn:@"PIMG"],@"PIMG",[s stringForColumn:@"PNAME"],@"PNAME",[s stringForColumn:@"PPHONE"],@"PPHONE", [s stringForColumn:@"PTIME"],@"PTIME",[s stringForColumn:@"UID"],@"UID",nil];
            [posts addObject:temp];
        }
    }
    
    [db close];
    return posts;
}




/**
 *  THIS WILL RETURN ALL NOTICEBOARDS
 *
 *  @return NSMutableArray
 */
+ (NSMutableArray*)queryBoard {
  FMDatabase *db = [self dbConnection];
    NSMutableArray *noticeBoards = [[NSMutableArray alloc] init];
  if ([db open]) {
    FMResultSet *s = [db executeQuery:@"SELECT * FROM NOTICEBOARD_T"];
      while ([s next]) {
          //inital an NSDictionary
          NSDictionary *temp = [[NSDictionary alloc] initWithObjectsAndKeys:[s stringForColumn:@"BNAME"],@"BNAME",[s stringForColumn:@"BID"],@"BID",[s stringForColumn:@"BIMAGE"],@"BIMAGE",[s stringForColumn:@"BGPS"],@"BGPS", [self queryPost:BOARDID:[s stringForColumn:@"BID"]],@"POSTS", nil];
          
          [noticeBoards addObject:temp];
      }
  }
    [db close];
    return noticeBoards;
}


/**
 *  query user information
 *
 *  @return return value description
 */
+ (NSDictionary *)queryUserInfo{
    FMDatabase *db = [self dbConnection];
    NSMutableDictionary *userQuery = [[NSMutableDictionary alloc] init];
    if ([db open]) {
        FMResultSet *s =
        [db executeQuery:@"SELECT * FROM USER_T WHERE LOGINSTATUS = ?",@"1"];
        if ([s next]) {
            [userQuery setObject:[s stringForColumn:@"UID"] forKey:@"UID"];
            [userQuery setObject:[s stringForColumn:@"UNICKNAME"] forKey:@"UNICKNAME"];
            [userQuery setObject:[s stringForColumn:@"UEMAIL"] forKey:@"UEMAIL"];
            [userQuery setObject:[s stringForColumn:@"ULOGIN_TIME"] forKey:@"ULOGIN_TIME"];
        }
    }
    [db close];
    
    return (NSDictionary*)userQuery;
}



@end
