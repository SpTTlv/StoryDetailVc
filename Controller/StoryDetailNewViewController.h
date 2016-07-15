//
//  StoryDetailNewViewController.h
//  小说详情
//
//  Created by Lv on 16/7/8.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "storyDetailBaWangView.h"
#import "StoryDetailTableViewCell.h"
#import "DetailFrame.h"
#import "DetailModel.h"
#import "TopView.h"
#import "TopModel.h"
#import "NSString+Fit.h"
#import "FourButtonView.h"
#import "FooterView.h"

#import "JJHTTPClient.h"
#import "SDImageCache.h"
#import "UIImage+image.h"
#import "UserInformationManager.h"
#import "RecentReadManager.h"
#import "BookshelfManager.h"
#import "appDefine.h"
#import "JrReaderViewController.h"
#import "temporaryBookshelfManager.h"
#import "VisitorLoginVcViewController.h"
#import "DBManager.h"
#import "authorSpecialColumnViewController.h"
#import "bookmarkViewController.h"
#import "allCommentController.h"
#import "downLoadViewController1.h"
#import "DESEncryption.h"
#import "StoryDetailCoverView.h"
#import "IrrigateView.h"
@interface StoryDetailNewViewController : BaseViewController
/**
 *  书籍id
 */
@property (nonatomic,strong) NSString *inovelId;
/**
 *  用户是否收藏了该书籍
 */
@property (nonatomic,strong) NSDictionary *isCollertDict;


- (id)init:(NSString *)novelId;
/**
 *  书籍的收藏状态
 */
@property (nonatomic,strong) NSString*collect;

/**
 *  弹出键盘上的取消按钮
 */
@property (nonatomic,strong) UIButton *cancelKeyboardBt;
/**
 *  tableView的坐标
 */
@property (nonatomic,assign) NSInteger pathRow;
/**
 *  tableView的数据 字典
 */
@property (nonatomic,strong) NSMutableDictionary *dictData;
/**
 *  霸王票View
 */
@property (nonatomic,weak) storyDetailBaWangView * bwView;
@end
