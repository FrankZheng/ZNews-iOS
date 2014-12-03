//
//  LibraryModel.m
//  ZNews
//
//  Created by Frank Zheng on 10/20/14.
//  Copyright (c) 2014 xzheng. All rights reserved.
//

#import "LibraryModel.h"
#import "ContentService.h"
#import "MOArticle+Dao.h"
#import "ModelUtil.h"
#import "NSArray+utility.h"

@implementation LibraryModel

+(instancetype)instance
{
    static LibraryModel *_instance;
    @synchronized(self)
    {
        if(_instance == nil) {
            _instance = [[LibraryModel alloc] init];
        }
    }
    return _instance;
}

- (void)updateNewsList:(NSArray *)articles completionBlock:(void(^)())completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSManagedObjectContext *moc = createBackgroundContext();
        __block int added = 0;
        
        [moc performBlockAndWait:^{
            NSMutableDictionary *articlesMap = [[NSMutableDictionary alloc]initWithCapacity:articles.count];
            for(NSDictionary *dict in articles) {
                [articlesMap setObject:dict forKey:dict[@"_id"]];
            }
            NSArray* sortedIds = [[articlesMap allKeys] sortedArrayUsingSelector:@selector(compare:)];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id IN %@", sortedIds];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Article" inManagedObjectContext:moc];
            request.sortDescriptors = @[sortDescriptor];
            request.entity = entity;
            request.predicate = predicate;
            
            NSError *error = nil;
            NSArray *results = [moc executeFetchRequest:request error:&error];
            
            [articlesMap removeObjectsForKeys:[results map:^id(id element) {
                return ((MOArticle *)element).id;
            }]];
            
            for (NSString *key in articlesMap) {
                [MOArticle insertArticleWithDictionary:articlesMap[key] inManagedObjectContext:moc];
                added++;
            }
            
            if([moc hasChanges]) {
                if(![moc save:&error]) {
                    NSLog(@"Failed to save articles, %@, %@", error, error.localizedDescription);
                }
                NSLog(@"insert %d new articles", added);
            } else {
                NSLog(@"no new articles");
            }
        }];
        
        completionBlock();
    });
}

- (void)update:(void(^)())completionBlock before:(NSDate *)beforeDate
{
    [[ContentService instance] getArticles:Tech
                                     limit:10
                                    before:beforeDate
                                   success:^(NSArray *articles) {
        [self updateNewsList:articles completionBlock:completionBlock];
    } failure:^{
        completionBlock();
    }];
}


@end
