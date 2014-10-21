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

-(void)update:(void(^)())completeBlock
{
    void(^successBlock)(NSArray *articles)  = ^(NSArray *articles){
        NSManagedObjectContext *moc = defaultManagedObjectContext();
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
        completeBlock();
    };
    
    [[ContentService instance] getArticles:Tech limit:20 success:^(NSArray *articles) {
#if 0
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            successBlock(articles);
        });
#else
        successBlock(articles);
#endif
    } failure:^{
        completeBlock();
    }];

    
}

@end
