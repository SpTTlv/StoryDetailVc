//
//  StoryDetailReplyTableViewCell.m
//  小说详情
//
//  Created by Lv on 16/7/8.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import "StoryDetailReplyTableViewCell.h"
#import "ReplyFrame.h"
#import "ReplyModel.h"
#define ColorRGB(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1.0f]
#define GRAY_Label ColorRGB(180, 180, 180)

@implementation StoryDetailReplyTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * cellID = @"StoryDetailReplyTableViewCell";
    StoryDetailReplyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[StoryDetailReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createCell];
        self.backgroundColor = ColorRGB(240, 240, 240);
    }
    return self;
}
- (void)createCell
{

    UILabel * nameLabel = [self labelCreate:12.0f Color:ColorRGB(0, 148, 108)];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    
    UILabel * floorLabel = [self labelCreate:12.0f Color:GRAY_Label];
    [self.contentView addSubview:floorLabel];
    floorLabel.textAlignment = NSTextAlignmentRight;
    self.floorLabel = floorLabel;
    
    UILabel * contentsLabel = [self labelCreate:12.0f Color:GRAY_Label];
    [self.contentView addSubview:contentsLabel];
    contentsLabel.numberOfLines = 0;
    self.contentsLabel = contentsLabel;
    
    UILabel * timeLabel = [self labelCreate:12.0f Color:GRAY_Label];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    

}
//布局 & 赋值
- (void)setReplyFrame:(ReplyFrame *)replyFrame
{
    _replyFrame = replyFrame;
    
    self.nameLabel.frame = replyFrame.reNameF;
    self.floorLabel.frame = replyFrame.reFloorNumF;
    self.contentsLabel.frame = replyFrame.reContentsF;
    self.timeLabel.frame = replyFrame.reTimeF;
    
    
    self.nameLabel.text = replyFrame.replyModel.replyAuthor;
    self.floorLabel.text = replyFrame.replyModel.reFloor;
    self.contentsLabel.text = replyFrame.replyModel.replyBody;
    self.timeLabel.text = replyFrame.replyModel.replyDate;

}
- (UILabel *)labelCreate:(CGFloat)fontFloat Color:(UIColor *)color;
{
    UILabel * label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:fontFloat];
    return label;
}
@end
