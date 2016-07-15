//
//  LastUpdateView.h
//  小说详情
//
//  Created by Lv on 16/7/7.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TargetLabel.h"

@class LastUpdateView;
@protocol LastChapterDelegate <NSObject>

@optional
- (void)lastChapterDelegateLast:(LastUpdateView *)lastUpView;

@end

@protocol LastDirectoryDelegate <NSObject>

@optional
- (void)lastDirectoryDelegateLast:(LastUpdateView *)lastUpView;

@end

@interface LastUpdateView : UIView

@property (nonatomic,weak) id<LastChapterDelegate> delegateChapter;
@property (nonatomic,weak) id<LastDirectoryDelegate> delegateDirectory;


/**
 *  目录
 */
@property (nonatomic,strong) UIButton *directoryBtn;
/**
 *  最新章节
 */
@property (nonatomic,strong) TargetLabel *renewChapter;

/**
 * 背景图盘
 */
@property (nonatomic,strong) UIImageView *backImage;

@property (nonatomic,strong) UILabel *lineLabel;

@property (nonatomic,strong) UILabel * renewLabel;

@property (nonatomic,assign) CGSize renewSize;

@property (nonatomic,strong) UIView *labelView;

@end
