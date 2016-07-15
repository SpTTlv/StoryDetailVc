 //
//  ReplyFrame.h
//  小说详情
//
//  Created by Lv on 16/7/8.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ReplyModel;
@interface ReplyFrame : NSObject
//有回复
/**
 *  有回复 的用户名
 */
@property (nonatomic,assign,readonly) CGRect reNameF;
/**
 *  有回复的楼层
 */
@property (nonatomic,assign,readonly) CGRect reFloorNumF;
/**
 *  有回复的 内容
 */
@property (nonatomic,assign,readonly) CGRect reContentsF;
/**
 *  有回复的 时间
 */
@property (nonatomic,assign,readonly) CGRect reTimeF;
/**
 *  cell高度
 */
@property (nonatomic,assign,readonly) CGFloat cellHeight;

/**
 *  数据模型
 */
@property (nonatomic,strong) ReplyModel *replyModel;



@end
