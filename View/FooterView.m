//
//  FooterView.m
//  小说详情
//
//  Created by Lv on 16/7/9.
//  Copyright © 2016年 Lv. All rights reserved.
//

#import "FooterView.h"
#define ColorRGB(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1.0f]

#define FONT_CONTENTS [UIFont systemFontOfSize:16.0f]

@implementation FooterView
{
    id _target;
    SEL _action;

}
- (void)setTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [_target performSelector:_action withObject:self];
#pragma clang diagnostic pop
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ColorRGB(240, 240, 240);
        self.userInteractionEnabled = YES;
    }

    return self;
}
- (void)setContents:(NSString *)contents
{
    _contents = contents;
    [self setNeedsDisplay];

}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {


    UIBezierPath * path = [UIBezierPath bezierPathWithRect:CGRectMake(1, 15, rect.size.width-2, 40)];
    [[UIColor blackColor] set];
    path.lineWidth  = 0.5;
    [path stroke];
    
    UIBezierPath * pathW = [UIBezierPath bezierPathWithRect:CGRectMake(2, 15+1, rect.size.width-4, 38)];
    [[UIColor whiteColor] set];
    [pathW fill];
    
    NSString * string = _contents;
    
    CGSize size = [string sizeWithAttributes:@{
                                               NSFontAttributeName:FONT_CONTENTS
                                               }];
    
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = FONT_CONTENTS;
    dic[NSForegroundColorAttributeName] = [UIColor redColor];
    
    [string drawAtPoint:CGPointMake((self.bounds.size.width - size.width)* 0.5, (self.bounds.size.height - size.height) * 0.5) withAttributes:dic];
    

    
    

}


@end
