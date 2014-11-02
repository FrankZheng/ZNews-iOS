//
//  DateFormatterUtils.h
//  ZNews
//
//  Created by Frank Zheng on 11/2/14.
//  Copyright (c) 2014 xzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateFormatterUtils : NSObject
+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSString *)stringFromDate:(NSDate *)date;

@end
