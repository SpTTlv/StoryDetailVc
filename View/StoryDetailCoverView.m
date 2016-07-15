//
//  StoryDetailCoverView.m
//  JINGJIANG-iOS
//
//  Created by Lv on 16/7/13.
//  Copyright © 2016年 Andy. All rights reserved.
//

#import "StoryDetailCoverView.h"

@implementation StoryDetailCoverView

+ (void)show
{
    StoryDetailCoverView * cover = [[StoryDetailCoverView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    cover.backgroundColor = [UIColor blackColor];
    
    cover.alpha = 0.6;
    
    [[UIApplication sharedApplication].keyWindow addSubview:cover];
}
+ (void)hide
{
    for (UIView * iv in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([iv isKindOfClass:self]) {
            [iv removeFromSuperview];
        }
    }

}

@end
