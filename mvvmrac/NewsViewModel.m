//
//  NewsViewModel.m
//  mvvmrac
//
//  Created by hejintao on 16/10/11.
//  Copyright © 2016年 hejintao. All rights reserved.
//

#import "NewsViewModel.h"
#import "NewsEntity.h"

@implementation NewsViewModel
- (instancetype)init
{
    if (self = [super init]) {
        [self setupRACCommand];
    }
    return self;
}

- (void)setupRACCommand
{
    @weakify(self);
    _fetchNewsEntityCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            [self requestForNewsEntityWithUrl:input success:^(NSArray *array) {
                NSArray *arrayM = [NewsEntity mj_objectArrayWithKeyValuesArray:array];
                [subscriber sendNext:arrayM];
                [subscriber sendCompleted];
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                [subscriber sendError:error];
            }];
            return nil;
        }];
    }];
}

- (void)requestForNewsEntityWithUrl:(NSString *)url success:(void (^)(NSArray *array))success failure:(void (^)(NSURLSessionTask *operation, NSError *error))failure{
    NSString *fullUrl = [@"http://c.m.163.com/" stringByAppendingString:url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:fullUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary* responseObject) {
        NSString *key = [responseObject.keyEnumerator nextObject];
        NSArray *temArray = responseObject[key];
        success(temArray);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error);
    }];
}
@end
