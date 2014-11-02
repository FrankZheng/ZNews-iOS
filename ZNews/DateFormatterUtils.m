//
//  DateFormatterUtils.m
//  ZNews
//
//  Created by Frank Zheng on 11/2/14.
//  Copyright (c) 2014 xzheng. All rights reserved.
//

#import "DateFormatterUtils.h"

static NSDateFormatter *ARTICLE_PUB_DATE_FMT = nil;


@implementation DateFormatterUtils
+ (void)initialize {
    ARTICLE_PUB_DATE_FMT = [[NSDateFormatter alloc] init];
    [ARTICLE_PUB_DATE_FMT setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    
}

+ (NSDate *)dateFromString:(NSString *)dateString {
    return [ARTICLE_PUB_DATE_FMT dateFromString:dateString];
}

+ (NSString *)stringFromDate:(NSDate *)date {
    return [ARTICLE_PUB_DATE_FMT stringFromDate:date];
}

@end
