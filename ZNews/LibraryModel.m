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
        int added = 0;
        
        for( NSDictionary *dict in articles)
        {
            //search the article in the db
            //search by ID
            //to improve it, could
            //1. add index
            //2. only search the latest news, like recent 8 hours, 4 hours.
            NSString* _id = dict[@"_id"];
            if(![MOArticle articleWithId:_id
                  inManagedObjectContext:moc]) {
                //save the article to db
                [MOArticle insertArticleWithDictionary:dict inManagedObjectContext:moc];
                added++;
            }
        }
        
        //Save
        NSError *error = nil;
        if(![moc save:&error]) {
            NSLog(@"Failed to save articles, %@, %@", error, error.localizedDescription);
        }
        NSLog(@"insert %d new articles", added);
        completionBlock();
    });
}

- (void)update:(void(^)())completionBlock
{
    [[ContentService instance] getArticles:Tech limit:50 success:^(NSArray *articles) {
        [self updateNewsList:articles completionBlock:completionBlock];
    } failure:^{
        completionBlock();
    }];
}

@end
