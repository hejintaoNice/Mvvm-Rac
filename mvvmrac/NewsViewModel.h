//
//  NewsViewModel.h
//  mvvmrac
//
//  Created by hejintao on 16/10/11.
//  Copyright © 2016年 hejintao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsViewModel : NSObject
/**
 *  获取新闻概要模型
 */
@property(nonatomic,strong)RACCommand *fetchNewsEntityCommand;
@end
