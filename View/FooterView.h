//
//  FooterView.h
//  小说详情
//
//  Created by Lv on 16/7/9.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FooterView : UIView
/**
 *  查看等多评论
 */
@property (nonatomic,strong) NSString *contents;

- (void)setTarget:(id)target action:(SEL)action;

@end
