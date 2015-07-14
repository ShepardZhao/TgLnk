//
//  NoticeBoardAndContentsNSObject.h
//  TgLnk
//
//  Created by Zhao, Shepard(AWF) on 7/4/15.
//  Copyright (c) 2015 com.xunzhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeBoardAndContentsNSObject : NSObject

//set the board title
@property (strong,nonatomic) NSString *boardTitle;

//set the board id
@property (strong,nonatomic) NSString *boardID;

//set the board image
@property (strong,nonatomic) NSString *boardImageAddress;

//set the board owner
@property (strong,nonatomic) NSString *boardOwner;

//set the board follow status
@property BOOL followStatus;

//set the owner image url
@property (strong,nonatomic) NSString *ownerImageUrl;

//set the first five posts
@property (strong,nonatomic) NSMutableArray *posts;

@end
