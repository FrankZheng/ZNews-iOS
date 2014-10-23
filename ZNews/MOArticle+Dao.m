//
//  MOArticle+Dao.m
//  ZNews
//
//  Created by Frank Zheng on 10/20/14.
//  Copyright (c) 2014 xzheng. All rights reserved.
//

#import "MOArticle+Dao.h"
#import "ModelUtil.h"

static NSString *ENTITY_NAME = @"Article";
static NSDateFormatter* PUB_DATE_FORMATER = nil;

@implementation MOArticle(Dao)

+ (void)initialize
{
    if(self == [MOArticle class]) {
        PUB_DATE_FORMATER = [[NSDateFormatter alloc] init];
        [PUB_DATE_FORMATER setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    }
}


+ (MOArticle *)insertArticleWithDictionary:(NSDictionary *)dict
                    inManagedObjectContext:(NSManagedObjectContext *)moc;
{
    MOArticle *article = (MOArticle *)[NSEntityDescription
                                       insertNewObjectForEntityForName:ENTITY_NAME inManagedObjectContext:moc];
    if(article) {
        article.title = dict[@"title"];
        article.id = dict[@"_id"];
        article.brief = dict[@"brief"];
        article.category = dict[@"category"];
        article.link = dict[@"link"];
        article.thumb = dict[@"thumb"];
        article.publisher = dict[@"publisher"];
        NSString* pubDate = dict[@"pubDate"];
        //parse the date
        article.pubDate = [PUB_DATE_FORMATER dateFromString:pubDate];
    }
    return article;
}

+ (MOArticle *)articleWithId:(NSString *)id
      inManagedObjectContext:(NSManagedObjectContext *)moc;
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", id];
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES]];
    MOArticle *article = (MOArticle *)fetchManagedObject(ENTITY_NAME,
                                                       predicate,
                                                       sortDescriptors,
                                                       moc);
    return article;
}

- (BOOL)save:(NSError **)error
{
    return [self.managedObjectContext save:error];
}

@end
