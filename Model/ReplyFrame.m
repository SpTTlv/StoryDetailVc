//
//  ReplyFrame.m
//  小说详情
//
//  Created by Lv on 16/7/8.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import "ReplyFrame.h"
#import "ReplyModel.h"
#import "NSString+Fit.h"

#define Scr_Width [UIScreen mainScreen].bounds.size.width
#define Scr_Height [UIScreen mainScreen].bounds.size.height

#define H(b) Scr_Height * b / 667
#define W(a) Scr_Width * a / 375

#define Height_Label 20
@implementation ReplyFrame

- (void)setReplyModel:(ReplyModel *)replyModel
{
    _replyModel = replyModel;
    CGFloat nameW = Scr_Width -20 - W(10) - 30;
    
    _reNameF = CGRectMake(W(5), H(3), nameW, Height_Label);
    
    _reFloorNumF = CGRectMake(Scr_Width - 30 - 30- W(5), H(3), 30, Height_Label);
    
    CGSize detailSize = [replyModel.replyBody sizeWithFont:[UIFont systemFontOfSize:12.0f] maxSize:CGSizeMake(Scr_Width - 30- W(10), MAXFLOAT)];
    _reContentsF = CGRectMake(W(5), CGRectGetMaxY(_reNameF), Scr_Width - 30- W(10), detailSize.height);
    
    _reTimeF = CGRectMake(W(5) , CGRectGetMaxY(_reContentsF), Scr_Width- 30 - W(10), Height_Label);
    NSLog(@"楼层的起点 %ld   宽度:  %ld",(long)_reFloorNumF.origin.x,(long)_reFloorNumF.size.width);
    _cellHeight = CGRectGetMaxY(_reTimeF);
    
}

@end
