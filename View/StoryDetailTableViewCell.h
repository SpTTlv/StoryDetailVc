//
//  StoryDetailTableViewCell.h
//  小说详情
//
//  Created by Lv on 16/7/7.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StoryDetailTableViewCell;
@protocol ReplyZhanKClickDelegate <NSObject>

@optional

- (void)replyZhanKClickBtn:(StoryDetailTableViewCell *)cell;

@end


@protocol ReplyCommentDelegate <NSObject>

@optional
- (void)replyCommentClickBtn:(StoryDetailTableViewCell *)cell;

@end

@class DetailFrame;
@interface StoryDetailTableViewCell : UITableViewCell
/**
 *  点击作者专栏
 */
@property (nonatomic,weak) id<ReplyZhanKClickDelegate> delegateZKButton;
/**
 *  点击 回复 按钮
 */
@property (nonatomic,weak) id <ReplyCommentDelegate> delegateReplyButton;


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) DetailFrame *detailFrame;
/**
 *  是否展开剩下楼层
 */
@property (nonatomic,assign) BOOL isAllShow;
/**
 *  有多少回复
 */
@property (nonatomic,assign) NSInteger isfloorNumCell;


/**
 *  楼中楼
 */
@property (nonatomic,weak) UITableView * replyTableView;




@end
