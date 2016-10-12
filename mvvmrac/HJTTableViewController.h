//
//  HJTTableViewController.h
//  mvvmrac
//
//  Created by hejintao on 16/10/11.
//  Copyright © 2016年 hejintao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJTTableViewController : UITableViewController
/**
 *  url端口
 */
@property(nonatomic,copy) NSString *urlString;

@property (nonatomic,assign) NSInteger index;
@end
