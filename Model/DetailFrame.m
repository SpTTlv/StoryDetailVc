//
//  DetailFrame.m
//  小说详情
//
//  Created by Lv on 16/7/7.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import "DetailFrame.h"
#import "NSString+Fit.h"
#import "ReplyFrame.h"
#define View_Left 5
#define View_Top  10
//打分 跟 时间的间距
#define Info_Time 10
#define Scr_Width [UIScreen mainScreen].bounds.size.width
#define Scr_Height [UIScreen mainScreen].bounds.size.height

//content的字体大小
#define Content_Font [UIFont systemFontOfSize:14.0f]

@implementation DetailFrame

- (void)setModel:(DetailModel *)model
{
    _model = model;
    
    CGSize timeSize  = [model.commentDate sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}];
    CGSize userNameSize  = [model.commentAuthor sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    if (userNameSize.width > (Scr_Width - 20) * 0.5) {
        userNameSize.width = (Scr_Width - 20) * 0.5;
        
    }
    _userNameF = CGRectMake(View_Left, View_Top,userNameSize.width , 20);
    
    _postTime = CGRectMake(Scr_Width- 10 - timeSize.width - 5, View_Top, timeSize.width, 20);

    _postInfoF = CGRectMake(CGRectGetMaxX(_userNameF)+3, View_Top, Scr_Width - 10 - CGRectGetMaxX(_userNameF)- 3 - _postTime.size.width-5- Info_Time, 20);
    
    //内容
    CGSize contentSize = [model.commentBody sizeWithFont:Content_Font maxSize:CGSizeMake(Scr_Width - 20 -30, MAXFLOAT) lineSpacing:0];
    
    _contentsF = CGRectMake(View_Left, CGRectGetMaxY(_userNameF)+5, contentSize.width, contentSize.height);
    
    _postBtnF = CGRectMake(Scr_Width - 20 - 30, CGRectGetMaxY(_contentsF) - 25, 30, 30);

    
    
    
    CGFloat tableViewH = 0;
//    for (ReplyFrame * replyFrame in _model.subcomments) {
//        tableViewH += replyFrame.cellHeight;
//    }
    CGFloat tableViewFootH = 0;
    for (int i = 0; i < _model.replyAll.count; i ++) {

        if ([_model.replyAll[i] isKindOfClass:[ReplyFrame class]]) {
            ReplyFrame * replyFrame = _model.replyAll[i];
            tableViewH += replyFrame.cellHeight;
            
        }
        
    }
    if (_isFloorNum > 5 && _isAll == NO) {
        tableViewFootH = 40;
    }
    
    
    _tableViewF = CGRectMake(View_Left *2, CGRectGetMaxY(_postBtnF), Scr_Width - 30, tableViewH +tableViewFootH);
    
    //button
    
    _cellHeight = CGRectGetMaxY(_tableViewF) + 10;
    

    

}
@end
