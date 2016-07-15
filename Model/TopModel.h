//
//  TopModel.h
//  小说详情
//
//  Created by Lv on 16/7/6.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TopModel : NSObject
/**
 *  书籍 封面 图片
 */
@property (nonatomic, strong) NSString * imageName;

@property (nonatomic, strong) NSString * contents;

//*bookName;
//*authorName;
//* bookStyle;
//* bookNum;
//*postNum;
//*noVClick;
//*numerical;


@property (nonatomic,strong) NSString *bookName;

@property (nonatomic,strong) NSString *authorName;

@property (nonatomic,strong) NSString *bookStyle;

@property (nonatomic,strong) NSString *bookNum;

@property (nonatomic,strong) NSString *postNum;

@property (nonatomic,strong) NSString *noVClick;
/**
 *  文章积分
 */
@property (nonatomic,strong) NSString *numerical;

@property (nonatomic,strong) NSString *protagonist;


@property (nonatomic,strong) NSString *costar;

@property (nonatomic,strong) NSString *other;

/**
 *  最新章节
 */
@property (nonatomic,strong) NSString *renewChapterName;


@property (nonatomic,strong) NSString *collectCount;

@property (nonatomic,strong) NSString *bwTicketCount;

@property (nonatomic,strong) NSString *irrigateCount;









@end
