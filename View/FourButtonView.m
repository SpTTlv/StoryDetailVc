//
//  FourButtonView.m
//  小说详情
//
//  Created by Lv on 16/7/7.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import "FourButtonView.h"

@implementation FourButtonView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
        

    }
    return self;
}
- (void)setUp
{

    
    [_collectBtn setTarget:self action:@selector(collectionClick)];
    
    [_bwTicket setTarget:self action:@selector(bwClick)];

    [_IrrigateBtn setTarget:self action:@selector(irrigateClick)];
}
//点击收藏
- (void)collectionClick
{

    if (_collectB) {
        _collectB();
    }
    if (_delegateCollect && [_delegateCollect respondsToSelector:@selector(baginToCollect:)]) {
        [_delegateCollect baginToCollect:self];
    }
}
//点击霸王票
- (void)bwClick
{
    if (_bwB) {
        _bwB();
    }
    if (_delegatebwp && [_delegatebwp respondsToSelector:@selector(baginTobwp:)]) {
        [_delegatebwp baginTobwp:self];
    }
}
//点击灌溉
- (void)irrigateClick
{
    if (_irrigateB) {
        _irrigateB();
    }
    if (_delegateIrri && [_delegateIrri respondsToSelector:@selector(baginToIrri:)]) {
        [_delegateIrri baginToIrri:self];
    }
    
}
//开始阅读
- (IBAction)beginRead:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(baginToRead:)]) {
        [_delegate baginToRead:self];
    }
    
    
}
- (void)awakeFromNib
{

    [self setUp];
}

@end
