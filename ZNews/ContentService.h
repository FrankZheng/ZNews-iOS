//
//  ContentService.h
//  Hello1
//
//  Created by Frank Zheng on 10/15/14.
//  Copyright (c) 2014 dps. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, Topic)
{
    All,
    Tech,
    Finance,
    Sports,
    Entertainment,
};

@interface ContentService : NSObject

-(void)getArticles:(Topic)topic
             limit:(NSInteger)limit
           success:(void(^)(NSArray *articles))successBlock
            failure:(void(^)())failureBlock;

+(instancetype) instance;

@end
