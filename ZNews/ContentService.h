//
//  ContentService.h
//  Hello1
//
//  Created by Frank Zheng on 10/15/14.
//  Copyright (c) 2014 dps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MOArticle;

typedef NS_ENUM(NSInteger, Topic)
{
    All,
    Tech,
    Finance,
    Sports,
    Entertainment,
};

@interface ContentService : NSObject

- (void)getArticles:(Topic)topic
             limit:(NSInteger)limit
             before:(NSDate *)beforeDate
           success:(void(^)(NSArray *articles))successBlock
            failure:(void(^)())failureBlock;

- (void)getArticleDetail:(MOArticle *)article
                  sucess:(void(^)(NSDictionary *data))success
                 failure:(void(^)())failure;

- (void)loadArticleThumbnail:(MOArticle *)article toImageView:(UIImageView *)imageView;

+(instancetype) instance;

@end
