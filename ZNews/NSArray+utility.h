//
//  NSArray+utility.h
//  ZNews
//
//  Created by Frank Zheng on 11/3/14.
//  Copyright (c) 2014 xzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray(utility)

- (NSArray *)map:(id(^)(id element))block;

@end
