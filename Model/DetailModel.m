//
//  DetailModel.m
//  小说详情
//
//  Created by Lv on 16/7/7.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import "DetailModel.h"
#import "ReplyModel.h"
#import "ReplyFrame.h"
@implementation DetailModel

+ (DetailModel *)modelWithDict:(NSDictionary *)dict
{
    
    
    return [[self alloc] initWithDict:dict];
    
}
- (DetailModel *)initWithDict:(NSDictionary *)dict
{
    if (self = [self init]) {
        NSMutableArray * array = [NSMutableArray array];

        [self setValuesForKeysWithDictionary:dict];
        

        if (self.replyAll.count) {
            int floor = 1;
            for (NSDictionary * dict in self.replyAll) {
                ReplyModel * replyModel  = [ReplyModel  modelWithDict:dict];
                replyModel.reFloor = [NSString stringWithFormat:@"%d楼",floor];
                ReplyFrame * frame  = [[ReplyFrame alloc] init];
                
                frame.replyModel = replyModel;
                [array addObject:frame];
                floor ++;
            }
            
            self.replyAll = array;
            
        }
        
    }
    return self;

}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}
- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}
@end
