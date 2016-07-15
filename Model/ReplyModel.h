//
//  ReplyModel.h
//  小说详情
//
//  Created by Lv on 16/7/8.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReplyModel : NSObject

//有回复
@property (nonatomic,strong) NSString *replyAuthor;

@property (nonatomic,strong) NSString *reFloor;


@property (nonatomic,strong) NSString *replyDate;

@property (nonatomic,strong) NSString *replyBody;

+ (ReplyModel*)modelWithDict:(NSDictionary *)dict;

- (ReplyModel *)initWithDict:(NSDictionary *)dict;

@end
