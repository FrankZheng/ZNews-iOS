//
//  ArticleDetail.h
//  ZNews
//
//  Created by Frank Zheng on 10/31/14.
//  Copyright (c) 2014 xzheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MOArticle;

@interface MOArticleDetail : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) MOArticle *article;

@end
