//
//  StoryDetailReplyTableViewCell.h
//  小说详情
//
//  Created by Lv on 16/7/8.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReplyFrame;
@interface StoryDetailReplyTableViewCell : UITableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) ReplyFrame *replyFrame;


@property (nonatomic,weak) UILabel *nameLabel;

@property (nonatomic,weak) UILabel *floorLabel;

@property (nonatomic,weak) UILabel *contentsLabel;

@property (nonatomic,weak) UILabel *timeLabel;





@end
