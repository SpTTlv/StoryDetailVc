//
//  IrrigateView.h
//  JINGJIANG-iOS
//
//  Created by Lv on 16/7/13.
//  Copyright © 2016年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IrrigateView;
@protocol IrrigateCancelDelegate <NSObject>

@optional
- (void)irrigateCancelClick:(IrrigateView *)irriView;

@end

@protocol IrrigateSureDelegate <NSObject>

@optional
- (void)irrigateSureClick:(IrrigateView *)irriView;

@end
@interface IrrigateView : UIView

@property (nonatomic,weak) id<IrrigateCancelDelegate> delegateCancel;
@property (nonatomic,weak) id<IrrigateSureDelegate> delegateSure;

@property (nonatomic,strong) NSMutableArray *arrAllBtn;


/**
 *  一瓶
 */
@property (strong, nonatomic) IBOutlet UIButton *oneIrrigate;
/**
 *  填写营养液数量
 */
@property (strong, nonatomic) IBOutlet UITextField *writeIrrigate;
/**
 *  全部营养液
 */
@property (strong, nonatomic) IBOutlet UIButton *allIrrigate;
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;
- (void)hideInPoint:(CGPoint)point completion:(void (^ __nullable)())completion;
+ (instancetype)showInPoint:(CGPoint)point;

@end
