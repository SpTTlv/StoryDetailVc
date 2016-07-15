//
//  DetailFrame.h
//  小说详情
//
//  Created by Lv on 16/7/7.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DetailModel.h"
@interface DetailFrame : NSObject
/**
 *  用户名字F
 */
@property (nonatomic,assign,readonly) CGRect userNameF;
/**
 *  评论信息F
 */
@property (nonatomic,assign,readonly) CGRect postInfoF;
/**
 *  评论时间F
 */
@property (nonatomic,assign,readonly) CGRect postTime;
/**
 *  评论内容F
 */
@property (nonatomic,assign,readonly) CGRect contentsF;
/**
 *  评论按钮F
 */
@property (nonatomic,assign,readonly) CGRect postBtnF;


/**
 *  数据模型
 */
@property (nonatomic,strong) DetailModel *model;
/**
 *  cell height
 */
@property (nonatomic,assign,readonly) CGFloat cellHeight;


/**
 *  评论列表高度
 */
@property (nonatomic,assign,readonly) CGRect tableViewF;
/**
 *  是否展示有footer
 */
@property (nonatomic,assign) BOOL isAll;

@property (nonatomic,assign) NSInteger isFloorNum;



@end
