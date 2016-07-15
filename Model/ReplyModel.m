//
//  ReplyModel.m
//  小说详情
//
//  Created by Lv on 16/7/8.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import "ReplyModel.h"

@implementation ReplyModel

+ (ReplyModel *)modelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
- (ReplyModel *)initWithDict:(NSDictionary *)dict
{

    if (self = [self init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
- (instancetype)valueForUndefinedKey:(NSString *)key
{
    return nil;
}
@end
