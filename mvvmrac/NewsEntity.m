//
//  NewsEntity.m
//  mvvmrac
//
//  Created by hejintao on 16/10/11.
//  Copyright © 2016年 hejintao. All rights reserved.
//

#import "NewsEntity.h"

@implementation NewsEntity
+ (instancetype)newsModelWithDict:(NSDictionary *)dict
{
    NewsEntity *model = [[self alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}
@end
