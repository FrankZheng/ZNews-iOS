//
//  NSArray+utility.m
//  ZNews
//
//  Created by Frank Zheng on 11/3/14.
//  Copyright (c) 2014 xzheng. All rights reserved.
//

#import "NSArray+utility.h"

@implementation NSArray(utility)

- (NSArray *)map:(id(^)(id element))block {
    NSMutableArray *result = [[NSMutableArray alloc]initWithCapacity:self.count];
    for(id element in self) {
        if (block != nil) {
            [result addObject:block(element)];
        }
    }
    return result;
}
@end
