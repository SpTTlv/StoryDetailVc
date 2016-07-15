//
//  IrrigateView.m
//  JINGJIANG-iOS
//
//  Created by Lv on 16/7/13.
//  Copyright © 2016年 Andy. All rights reserved.
//

#import "IrrigateView.h"

#define Btn_background [UIColor colorWithRed:93/255.0 green:232/255.0 blue:198/255.0 alpha:1.0f]
@implementation IrrigateView

+ (instancetype)showInPoint:(CGPoint)point
{
    IrrigateView * popMune = [[NSBundle mainBundle] loadNibNamed:@"IrrigateView" owner:nil options:nil][0];
    popMune.center = point;
    
    [[UIApplication sharedApplication].keyWindow addSubview:popMune];
    
    return popMune;

}
- (NSMutableArray *)arrAllBtn
{
    if (_arrAllBtn == nil) {
        _arrAllBtn = [[NSMutableArray alloc] initWithObjects:self.oneIrrigate,self.allIrrigate, nil];
    }
    return _arrAllBtn;
}
- (IBAction)cancelClick:(id)sender {
    
    if (_delegateCancel && [_delegateCancel respondsToSelector:@selector(irrigateCancelClick:)]) {
        [_delegateCancel irrigateCancelClick:self];
    }
    
    
}
- (IBAction)btnClick:(UIButton *)sender {
    
    self.writeIrrigate.text = @"";
    [self.writeIrrigate resignFirstResponder];
    for (UIButton * btn  in self.arrAllBtn) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn == sender) {
                btn.selected = YES;
                [btn setBackgroundColor:Btn_background];
            }else{
                btn.selected = NO;
                [btn setBackgroundColor:[UIColor whiteColor]];
            }
        }
    }
    
    
}

- (IBAction)writeNumClick:(UITextField *)sender {
    
    for (UIButton * btn  in self.arrAllBtn) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.selected = NO;
            [btn setBackgroundColor:[UIColor whiteColor]];
        }
    }
    [sender becomeFirstResponder];
}
- (void)hideInPoint:(CGPoint)point completion:(void (^)())completion
{
    [UIView animateWithDuration:0.5 animations:^{
        
        self.center = point;
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        completion();
    }];

    
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.writeIrrigate resignFirstResponder];
}
- (IBAction)sureClick:(UIButton *)sender {
    
    if (_delegateSure && [_delegateSure respondsToSelector:@selector(irrigateSureClick:)]) {
        [_delegateSure irrigateSureClick:self];
    }

}
@end
