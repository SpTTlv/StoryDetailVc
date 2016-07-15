//
//  FourButtonView.h
//  小说详情
//
//  Created by Lv on 16/7/7.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TargetView.h"
@class FourButtonView;
@protocol BeginToReadDelegate <NSObject>

@optional
- (void)baginToRead:(FourButtonView *)fourBtnView;

@end

@protocol BeginToCollectDelegate <NSObject>

@optional
- (void)baginToCollect:(FourButtonView *)fourBtnView;

@end
@protocol BeginTobwpDelegate <NSObject>

@optional
- (void)baginTobwp:(FourButtonView *)fourBtnView;

@end

@protocol BeginToIrriDelegate <NSObject>

@optional
- (void)baginToIrri:(FourButtonView *)fourBtnView;

@end
typedef void(^collectBlock)();
typedef void(^bwTicketBlock)();
typedef void(^irrigateBlock)();
@interface FourButtonView : UIView
/**
 *  开始阅读
 */
@property (nonatomic,weak) id<BeginToReadDelegate> delegate;
/**
 *  收藏
 */
@property (nonatomic,weak) id<BeginToCollectDelegate> delegateCollect;
/**
 *  bwp
 */
@property (nonatomic,weak) id<BeginTobwpDelegate> delegatebwp;
/**
 *  Irri
 */
@property (nonatomic,weak) id<BeginToIrriDelegate> delegateIrri;
/**
 *  收藏
 */
@property (nonatomic,strong) collectBlock collectB;
/**
 *  霸王票
 */
@property (nonatomic,strong) bwTicketBlock bwB;
/**
 *  灌溉
 */
@property (nonatomic,strong) irrigateBlock irrigateB;

/**
 *  收藏
 */
@property (strong, nonatomic) IBOutlet TargetView *collectBtn;
/**
 *  霸王票
 */
@property (strong, nonatomic) IBOutlet TargetView *bwTicket;
/**
 *  灌溉
 */
@property (strong, nonatomic) IBOutlet TargetView *IrrigateBtn;

/**
 *  收藏 && 已收藏
 */
@property (strong, nonatomic) IBOutlet UILabel *collectLabel;
/**
 *  收藏数目
 */
@property (strong, nonatomic) IBOutlet UILabel *collectCount;
/**
 *  霸王票 数目
 */
@property (strong, nonatomic) IBOutlet UILabel *bwTicketCount;
/**
 *  灌溉 数目
 */
@property (strong, nonatomic) IBOutlet UILabel *irrigateCount;

@end
