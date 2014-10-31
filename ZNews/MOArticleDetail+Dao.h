//
//  MOArticleDetail+Dao.h
//  ZNews
//
//  Created by Frank Zheng on 10/31/14.
//  Copyright (c) 2014 xzheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOArticleDetail.h"

@interface MOArticleDetail(Dao)

+(MOArticleDetail *)insertArticleDetailWithDictionary:(NSDictionary *)data
                               inManagedObjectContext:(NSManagedObjectContext *)moc
                                     relatedToArticle:(MOArticle *)article;



@end
