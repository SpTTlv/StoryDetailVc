//
//  StoryDetailTableViewCell.m
//  小说详情
//
//  Created by Lv on 16/7/7.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import "StoryDetailTableViewCell.h"
#import "StoryDetailReplyTableViewCell.h"
#import "DetailFrame.h"
#import "DetailModel.h"


#define Scr_Width [UIScreen mainScreen].bounds.size.width
#define Scr_Height [UIScreen mainScreen].bounds.size.height
#define ColorRGB(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1.0f]
#define GRAY_Label ColorRGB(180, 180, 180)



@interface StoryDetailTableViewCell()<
UITableViewDataSource,
UITableViewDelegate
>
@property (nonatomic,strong) NSMutableArray * arrayData;


@property(nonatomic, weak)UILabel * nameLabel;
@property(nonatomic, weak)UILabel * postInfoLabel;
@property(nonatomic, weak)UILabel * timeLabel;
@property(nonatomic, weak)UILabel * contentsLabel;

@property(nonatomic, weak)UIButton * replyButton;



@end


@implementation StoryDetailTableViewCell
- (NSMutableArray *)arrayData
{
    if (_arrayData == nil) {
        _arrayData = [NSMutableArray array];
    }
    return _arrayData;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString * cellid = @"StoryDetailTableViewCell";
    StoryDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[StoryDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.isAllShow = NO;
        self.isfloorNumCell = 0;
        self.backgroundColor  = [UIColor whiteColor];
        [self creatCell];
    }
    return self;
}
- (void)creatCell
{
    UILabel * nameLabel = [self labelCreate:14.0f Color:ColorRGB(0, 148, 108)];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel * posetInfo = [self labelCreate:12.0f Color:GRAY_Label];
    posetInfo.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:posetInfo];
    self.postInfoLabel = posetInfo;
    
    UILabel * timeLabel = [self labelCreate:12.0f Color:GRAY_Label];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UILabel * contentsLabel = [self labelCreate:14.0f Color:GRAY_Label];
    contentsLabel.numberOfLines = 0;
    [self.contentView addSubview:contentsLabel];
    self.contentsLabel = contentsLabel;
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.bounces = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:tableView];
    self.replyTableView = tableView;

    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"reply"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(replyClick) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    [self.contentView addSubview:button];
    self.replyButton = button;


}
- (void)replyClick
{
    if (_delegateReplyButton && [_delegateReplyButton respondsToSelector:@selector(replyCommentClickBtn:)]) {
        [_delegateReplyButton replyCommentClickBtn:self];
    }

}
//赋值 & 布局
- (void)setDetailFrame:(DetailFrame *)detailFrame
{

    _detailFrame = detailFrame;
    
    DetailModel * model = detailFrame.model;
    
    self.isAllShow = detailFrame.isAll;
    
    self.isfloorNumCell = detailFrame.isFloorNum;
    
    self.nameLabel.frame = detailFrame.userNameF;
    self.timeLabel.frame = detailFrame.postTime;
    self.postInfoLabel.frame = detailFrame.postInfoF;
    self.contentsLabel.frame = detailFrame.contentsF;
    self.replyTableView.frame = detailFrame.tableViewF;
    self.replyButton.frame = detailFrame.postBtnF;
    if (self.arrayData.count) {
        [self.arrayData removeAllObjects];
    }
    [self.arrayData addObjectsFromArray:model.replyAll];
    [self.replyTableView reloadData];
    
    
    //赋值
    self.nameLabel.text = model.commentAuthor;
    self.timeLabel.text = model.commentDate;
//    self.postInfoLabel.text = [NSString stringWithFormat:@"所评章节:%@  打分:%@",model.chapterId,model.commentMark];
    NSString * attStr =[NSString stringWithFormat:@"所评章节:%@  打分:%@",model.chapterId,model.commentMark];
    NSRange  range = [attStr rangeOfString:model.chapterId];
    NSRange  range2 = [attStr rangeOfString:model.commentMark];
    NSRange  range3 = [attStr rangeOfString:@"所评章节:"];
    NSRange  range4 = [attStr rangeOfString:@"打分:"];
    NSMutableAttributedString*attribute = [[NSMutableAttributedString alloc] initWithString: attStr];
    [attribute addAttributes: @{NSForegroundColorAttributeName: ColorRGB(0, 148, 108)}range: range];
    [attribute addAttributes:@{NSForegroundColorAttributeName:ColorRGB(0, 148, 108)} range:range2];
    [attribute addAttributes:@{NSForegroundColorAttributeName:GRAY_Label} range:range3];
    [attribute addAttributes:@{NSForegroundColorAttributeName:GRAY_Label} range:range4];

    [self.postInfoLabel setText:attStr];
    [self.postInfoLabel setAttributedText:attribute];
    
    self.contentsLabel.text = model.commentBody;

}

- (UILabel *)labelCreate:(CGFloat)fontFloat Color:(UIColor *)color;
{
    UILabel * label = [[UILabel alloc] init];
    label.textColor = color;
    label.font = [UIFont systemFontOfSize:fontFloat];
    return label;
}


#pragma mark = tableViewDeleagte
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

//    return _isAllShow?self.arrayData.count:self.arrayData.count > 5?5:self.arrayData.count;
    return self.arrayData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.replyTableView.tableFooterView removeFromSuperview];

//        [self setupFooterView];
 
    
    StoryDetailReplyTableViewCell * cell = [StoryDetailReplyTableViewCell cellWithTableView:tableView];
    cell.replyFrame= self.arrayData[indexPath.row];
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailFrame * model =self.arrayData[indexPath.row];
    return model.cellHeight;
}

/**
 *  创建尾部视图
 */
- (void)setupFooterView{
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,Scr_Width - 30 ,30)];
    backView.backgroundColor = [UIColor purpleColor];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"查看剩余其他回复" forState:UIControlStateNormal];
    [btn setTitleColor:ColorRGB(0, 148, 108) forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 40, 30);
    btn.center = CGPointMake(backView.bounds.size.width * 0.5, backView.bounds.size.height * 0.5);
    [btn addTarget:self action:@selector(floorClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btn];
    self.replyTableView.tableFooterView = backView;

}
/**
 *  展开剩下楼层
 */
- (void)floorClick
{
//    _isAllShow = YES;
//    [self.replyTableView reloadData];
    if ([_delegateZKButton respondsToSelector:@selector(replyZhanKClickBtn:)]) {
        [_delegateZKButton replyZhanKClickBtn:self];
    }
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,Scr_Width - 30 ,40)];
    backView.backgroundColor = ColorRGB(240, 240, 240);
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSString * isfloor = [NSString stringWithFormat:@"查看剩余%ld条回复",(long)(self.isfloorNumCell -5)];
    NSRange range = [isfloor rangeOfString:[NSString stringWithFormat:@"%ld条",(long)(self.isfloorNumCell -5)]];
    NSRange range2 = [isfloor rangeOfString:@"查看剩余"];
    NSRange range3 = [isfloor rangeOfString:@"回复"];
    NSMutableAttributedString*attribute = [[NSMutableAttributedString alloc] initWithString: isfloor];
    [attribute addAttributes: @{NSForegroundColorAttributeName: ColorRGB(0, 148, 108)}range: range];
    [attribute addAttributes:@{NSForegroundColorAttributeName: ColorRGB(140, 140, 140)} range:range2];
    [attribute addAttributes:@{NSForegroundColorAttributeName: ColorRGB(140, 140, 140)} range:range3];
    [btn setTitle:isfloor forState:UIControlStateNormal];
    [btn setAttributedTitle:attribute forState:UIControlStateNormal];
    [btn setTitleColor:GRAY_Label forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, Scr_Width-30, 40);
    btn.center = CGPointMake(backView.bounds.size.width * 0.5, backView.bounds.size.height * 0.5);
    [btn addTarget:self action:@selector(floorClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btn];
    return backView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_isfloorNumCell > 5 && _isAllShow == NO) {
        return 40;
    }else{
        return 0;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
