//
//  TopView.h
//  小说详情
//
//  Created by Lv on 16/7/5.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopModel.h"
#import "AuthorZLView.h"
#import "FourButtonView.h"
#import "LastUpdateView.h"
@class TopView;
typedef void(^DownBtnBlock)();

typedef void(^authorZLBlock)();

@protocol TopViewDelegate <NSObject>

@optional
- (void)topViewBtnClick:(TopView *)topView;

@end
@protocol TopViewDownDelegate <NSObject>

@optional
- (void)topViewDown:(TopView *)topView;

@end
@protocol TopViewauthorZLDelegate <NSObject>

@optional
- (void)topViewauthorZL:(TopView *)topView;

@end

@interface TopView : UIView

@property (nonatomic,strong) DownBtnBlock downBlock;

@property (nonatomic,strong) authorZLBlock authorZLBlock;

@property (nonatomic,weak) id<TopViewauthorZLDelegate> delegateauthorZL;
@property (nonatomic,weak) id<TopViewDownDelegate> delegateDown;

@property (nonatomic,weak) id<TopViewDelegate> delegate;

@property (nonatomic, strong)TopModel * model;
/**
 *  文章简介
 */
@property (nonatomic,strong) TargetLabel *contentL;
/**
 *  文章图片
 */
@property (nonatomic,strong) UIImageView *topImage;
/**
 *  btn
 */
@property (nonatomic,strong) UIButton *clickBtn;
/**
 *
 */
@property (nonatomic,assign) CGFloat viewH;

@property (nonatomic,assign) CGSize contentSize;
/**
 *  书名
 */
@property (nonatomic,strong) UILabel *bookName;
/**
 *  作者名字
 */
@property (nonatomic,strong) UILabel *authorName;
/**
 *  文章类型
 */
@property (nonatomic,strong) UILabel * bookStyle;
/**
 *  全文字数
 */
@property (nonatomic,strong) UILabel * bookNum;
/**
 *  评论 数
 */
@property (nonatomic,strong) UILabel *postNum;
/**
 *  非V点击
 */
@property (nonatomic,strong) UILabel *noVClick;
/**
 *  文章积分
 */
@property (nonatomic,strong) UILabel *numerical;
/**
 *  作者专栏
 */
@property (nonatomic,strong) AuthorZLView *authorZL;
/**
 *  下载按钮
 */
@property (nonatomic,strong) UIButton *downloadBtn;


/**
 *  4个button按钮
 */
@property (nonatomic,strong) FourButtonView *fourButtonView;
/**
 *  最新更新
 */
@property (nonatomic,strong) LastUpdateView *lastView;
/**
 *  主角
 */
@property (nonatomic,strong) UILabel *major;

/**
 * 配角
 */
@property (nonatomic,strong) UILabel *costar;
/**
 *  其他
 */
@property (nonatomic,strong) UILabel *other;
/**
 *  底部灰色
 */
@property (nonatomic,strong) UILabel *bottonGray;
/**
 *  最底部灰色
 */
@property (nonatomic,strong) UILabel *bottonGrayLast;
/**
 *   评论:tableview
 */
@property (nonatomic,strong) UILabel *redPostLabel;




@end
