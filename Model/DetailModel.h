//
//  DetailModel.h
//  小说详情
//
//  Created by Lv on 16/7/7.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject
/**
 *  名字
 */
@property (nonatomic,strong) NSString *commentAuthor;
/**
 *  时间
 */
@property (nonatomic,strong) NSString *commentDate;
/**
 *  信息:所评章节:
 */
@property (nonatomic,strong) NSString *chapterId;
/**
 *  打分
 */
@property (nonatomic,strong) NSString *commentMark;


/**
 *  内容
 */
@property (nonatomic,strong) NSString *commentBody;

/**
 *  回复人的id
 */
@property (nonatomic,strong) NSString *commentId;


/**
 *  评论此楼层的评论内容数组（里面都是楼中楼评论内容Frame模型）
 */
@property (nonatomic,strong) NSArray * replyAll;

@property (nonatomic,assign) BOOL isFooterShow;


-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

+ (DetailModel*)modelWithDict:(NSDictionary *)dict;

- (DetailModel *)initWithDict:(NSDictionary *)dict;
@end
