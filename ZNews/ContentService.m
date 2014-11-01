//
//  ContentService.m
//  Hello1
//
//  Created by Frank Zheng on 10/15/14.
//  Copyright (c) 2014 dps. All rights reserved.
//

#import "ContentService.h"
#import "AFNetworking.h"
#import "MOArticle.h"
#import "MOArticle+Dao.h"
#import "UIImageView+AFNetworking.h"

@implementation ContentService
-(NSString*)getTopicQueryValue:(Topic)topic
{
    static NSDictionary* topicQueryValues = nil;
    if(topicQueryValues == nil) {
        topicQueryValues = @{@(All): @"all",
                             @(Tech) : @"t",
                             @(Finance) : @"b",
                             @(Sports) : @"s",
                             @(Entertainment) : @"e"};
    }
    return topicQueryValues[@(topic)];
}

-(void)getArticles:(Topic)topic
             limit:(NSInteger)limit
           success:(void(^)(NSArray* articles))successBlock
           failure:(void(^)())failureBlock
{
    AFHTTPRequestOperationManager *manager = [self createRequestManager];
    NSString *url = @"http://xnewsreader.herokuapp.com/articles";
    //set query parameter
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithCapacity:3];
    if(topic != All) {
        params[@"topic"] = [self getTopicQueryValue:topic];
    }
    params[@"limit"] = [@(limit) stringValue];
    params[@"output"] = @"json";
    
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSArray class]]) {
            NSArray* articles = (NSArray*)responseObject;
            successBlock(articles);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        failureBlock();
    }];
}

- (void)getArticleDetail:(MOArticle *)article
                  sucess:(void(^)(NSDictionary *data))success
                 failure:(void(^)())failure
{
    AFHTTPRequestOperationManager *manager = [self createRequestManager];
    NSString *url = [NSString stringWithFormat:@"http://xnewsreader.herokuapp.com/article/%@", article.id];
    NSDictionary* params =@{@"output" : @"json"};
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary* data = (NSDictionary*)responseObject;
            success(data);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        failure();
    }];
}

- (NSString *)encodeQueryParamterPair:(NSString *)key value:(NSString *)value
{
    NSString *escapedString = [value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [NSString stringWithFormat:@"%@=%@", key, escapedString];
}

- (void)loadArticleThumbnail:(MOArticle *)article toImageView:(UIImageView *)imageView
{
    NSString *thumbUrl = [NSString stringWithFormat:@"http://xnewsreader.herokuapp.com/thumb?%@",
                          [self encodeQueryParamterPair:@"thumburl" value:article.thumb]];
    [imageView setImageWithURL:[NSURL URLWithString:thumbUrl]
              placeholderImage:[UIImage imageNamed:@"thumb_placeholder"]];
}


+(instancetype) instance
{
    //There may have better solution
    //http://stackoverflow.com/questions/8796529/singleton-in-ios-5
    static ContentService* instance = nil;
    @synchronized(self)
    {
        if(instance == nil) {
            instance = [[ContentService alloc] init];
        }
    }
    return instance;
}


- (AFHTTPRequestOperationManager*) createRequestManager
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
    manager.responseSerializer = responseSerializer;
    
    return manager;
}


@end
