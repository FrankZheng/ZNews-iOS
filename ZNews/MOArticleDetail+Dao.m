//
//  MOArticleDetail+Dao.m
//  ZNews
//
//  Created by Frank Zheng on 10/31/14.
//  Copyright (c) 2014 xzheng. All rights reserved.
//

#import "MOArticleDetail+Dao.h"
#import "MOArticle+Dao.h"

static NSString *ENTITY_NAME = @"ArticleDetail";

@implementation MOArticleDetail(Dao)

+ (MOArticleDetail *)insertArticleDetailWithDictionary:(NSDictionary *)data
                               inManagedObjectContext:(NSManagedObjectContext *)moc
                                    relatedToArticle:(MOArticle *)article
{
    MOArticleDetail *articleDetail = (MOArticleDetail *)[NSEntityDescription
                                       insertNewObjectForEntityForName:ENTITY_NAME inManagedObjectContext:moc];
    articleDetail.id = data[@"id"];
    articleDetail.text = data[@"text"];
    
    if(article != nil)
    {
        //connect to each other
        article.detail = articleDetail;
        articleDetail.article = article;
    }
    
    return articleDetail;
    
}
@end
