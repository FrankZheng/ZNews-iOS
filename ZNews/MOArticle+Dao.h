//
//  MOArticle+Dao.h
//  ZNews
//
//  Created by Frank Zheng on 10/20/14.
//  Copyright (c) 2014 xzheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOArticle.h"

@interface MOArticle(Dao)

- (BOOL)save:(NSError **)error;

+ (MOArticle *)insertArticleWithDictionary:(NSDictionary *)dict
                    inManagedObjectContext:(NSManagedObjectContext *)moc;

+ (MOArticle *)articleWithId:(NSString *)id
      inManagedObjectContext:(NSManagedObjectContext *)moc;

//may need add category parameter later
+(MOArticle *)getOldestArticle:(NSString *)category
        inManagedObjectContext:(NSManagedObjectContext *)moc;


@end
