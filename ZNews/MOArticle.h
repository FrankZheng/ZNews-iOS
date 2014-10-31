//
//  Article.h
//  ZNews
//
//  Created by Frank Zheng on 10/20/14.
//  Copyright (c) 2014 xzheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MOArticleDetail.h"


@interface MOArticle : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * brief;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSDate * pubDate;
@property (nonatomic, retain) NSString * publisher;
@property (nonatomic, retain) NSString * thumb;
@property (nonatomic, retain) MOArticleDetail *detail;

@end
