//
//  MOArticleDetail+Dao.m
//  ZNews
//
//  Created by Frank Zheng on 10/31/14.
//  Copyright (c) 2014 xzheng. All rights reserved.
//

#import "MOArticleDetail+Dao.h"
static NSString *ENTITY_NAME = @"ArticleDetail";

@implementation MOArticleDetail(Dao)

+ (MOArticleDetail *)insertArticleDetailWithDictionary:(NSDictionary *)data
                               inManagedObjectContext:(NSManagedObjectContext *)moc
{
    MOArticleDetail *articleDetail = (MOArticleDetail *)[NSEntityDescription
                                       insertNewObjectForEntityForName:ENTITY_NAME inManagedObjectContext:moc];
    articleDetail.id = data[@"id"];
    articleDetail.text = data[@"text"];
    
    
    
    return articleDetail;
    
}
@end
