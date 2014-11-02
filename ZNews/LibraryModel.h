//
//  LibraryModel.h
//  ZNews
//
//  Created by Frank Zheng on 10/20/14.
//  Copyright (c) 2014 xzheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LibraryModel : NSObject

+(instancetype)instance;

-(void)update:(void(^)())completionBlock before:(NSDate *)beforeDate;

@end
